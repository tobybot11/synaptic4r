############################################################################################################
module Synaptic4r
  
  ##########################################################################################################
  class Result

    #.......................................................................................................
    attr_reader :headers, :url, :http_request, :sign, :payload

    #.......................................................................................................
    def initialize(args)
      @http_request = args[:http_request]
      @headers = args[:headers]
      @url = args[:url]
      @sign =  args[:sign]
      @payload = args[:payload]
    end

    #.......................................................................................................
    def print
    end

  protected 

    #.......................................................................................................
    def extract_header(args, header)
      headers = args[:result].headers[header]
      if headers
        headers.split(/,\s+/).map{|a| a.strip}.inject({}) do |r,a| 
          v = a.split('=')
          v << 'N/A' if v.length < 2
          r.update(v.first => v.last)
        end
      else
        {}
      end    
    end

    #.......................................................................................................
    def stringify_hash(h)
      h.inject(""){|r,(u,a)| r += "  #{u}=#{a}\n"}
    end
   

    #.......................................................................................................
    def stringify_array(a)
      a.split(/,\s+/).sort.inject(""){|s,t| s += "#{t}, "}.chomp(', ') if a
    end
   

  #Response
  end 

  ##########################################################################################################
  class StorageObject < Result
    
    #.......................................................................................................
    def initialize(args)
      super
      if args[:result]
        @location = args[:result].headers[:location]
        @date = args[:result].headers[:date]
        @size = args[:result].headers[:x_emc_delta]
        @oid = /\/rest\/objects\/(.*)/.match(@location).captures.first
      end
    end

    #.......................................................................................................
    def print
      (@oid.nil? ? '' : "OID:  #{@oid}\n") + 
      (@size.nil? ? '' : "size: #{@size} bytes")
    end

  #Upload
  end 

  ##########################################################################################################
  class UserMetadata < Result
    
    #.......................................................................................................
    def initialize(args)
      super
      if args[:result]
        @metadata = extract_header(args, :x_emc_meta)
        @listable_metadata = extract_header(args, :x_emc_listable_meta)
      end
    end

    #.......................................................................................................
    def print
      unless @metadata.empty? and @listable_metadata.empty?
        (@metadata.empty? ? '' : "Not Listable Metadata\n#{stringify_hash(@metadata)}") +
          (@listable_metadata.empty? ? '' : "Listable Metadata\n#{stringify_hash(@listable_metadata)}")
      end
    end

  #UserMetadata
  end 


  ##########################################################################################################
  class SystemMetadata < Result
    
    #.......................................................................................................
    def initialize(args)
      super
      if args[:result]
        @metadata = extract_header(args, :x_emc_meta)
      end
    end

    #.......................................................................................................
    def print
      stringify_hash(@metadata)
    end

  #SystemMetadata
  end 


  ##########################################################################################################
  class Tags < Result
    
    #.......................................................................................................
    def initialize(args)
      super
      if args[:result]
        @listable_tags = args[:result].headers[:x_emc_listable_tags]
      end
    end

    #.......................................................................................................
    def print
      stringify_array(@listable_tags)
    end

  #Metadata
  end 

  ##########################################################################################################
  class Acl < Result
    
    #.......................................................................................................
    def initialize(args)
      super
      if args[:result]
        @user_acl = extract_header(args, :x_emc_useracl)
        @group_acl = extract_header(args, :x_emc_groupacl)
      end
    end

    #.......................................................................................................
    def print
      "User ACL\n#{stringify_hash(@user_acl)}Group ACL\n#{stringify_hash(@group_acl)}"
    end

  #Acl
  end 

  ##########################################################################################################
  class Versions < Result
    
    #.......................................................................................................
    def initialize(args)
      super
      if args[:result]
        @versions =  REXML::Document.new(args[:result].net_http_res.body).root
      end
    end

    #.......................................................................................................
    def print
      poids = oids
      poids.inject("") {|r,o| r += "  #{o}\n"} unless poids.empty?
    end

  private

    #.......................................................................................................
    def oids
      @versions.elements.to_a('ObjectID').map{|o| o.text}      
    end

  #Acl
  end 


  ##########################################################################################################
  class StorageObjectList < Result
    
    #.......................................................................................................
    def initialize(args)
      super
      if args[:result]
        @objs =  REXML::Document.new(args[:result].net_http_res.body).root
      end
     end

    #.......................................................................................................
    def print
      ols = objs
      oid = oids(ols); sys_meta = metadata(ols, 'SystemMetadataList')
      unless sys_meta.empty?
        fmt = "%-30s %-10s %-s\n"
        fmt % ['Name', 'Type', 'OID'] +
        sys_meta.inject("") do |r,e| 
          t = e['type']
          r += fmt % [e['objname'], (t.eql?('regular') ? 'file' : t), e['objectid']]
        end
      else
        "OID\n" + oid.join("\n").chomp
      end
    end

  private

    #.......................................................................................................
    def oids(ols)
      ols.map{|o| o.elements.to_a('ObjectID').first.text}   
    end

    #.......................................................................................................
    def metadata(ols, tag)
      meta = ols.map{|o| o.elements.to_a(tag)}
      meta.map{|a| a.first.elements.to_a.inject({}){|h,s| h.update(extract_attrs(s))}}
    end

    #.......................................................................................................
    def extract_attrs(a)
      {a.elements.to_a('Name').first.text => a.elements.to_a('Value').first.text}
    end

    #.......................................................................................................
    def objs
      @objs.elements.to_a('Object')      
    end


  #SorageObjectList
  end 

  ##########################################################################################################
  class Download < Result
    
    #.......................................................................................................
    def initialize(args)
      super   
      if args[:result]
        @content_type = args[:result].headers[:content_type]   
        @body = args[:result].net_http_res.body     
      end
    end

    #.......................................................................................................
    def print
      if @content_type.eql?('text/xml')
        print_directory_entries
      else
        @body
      end
    end

  private

    #.......................................................................................................
    def directory_entries
      REXML::Document.new(@body).root.elements.to_a.first.elements.to_a.map do |i|
        i.elements.inject(nil, {}){|h,e| h.update(e.name => e.text)}
      end
    end

    #.......................................................................................................
    def print_directory_entries
      dir_list = directory_entries
      unless dir_list.empty?
        fmt = "%-30s %-10s %-s\n"
        fmt % ['Name', 'Type', 'OID'] +
        dir_list.inject("") do |r,e| 
          t = e['FileType']
          r += fmt % [e['Filename'], (t.eql?('regular') ? 'file' : t), e['ObjectID']]
        end
      end
    end

    #.......................................................................................................
    def octet_stream
      @body
    end

  #RetrievedFile
  end 

  ##########################################################################################################
  class RequestError
    
    #.......................................................................................................
    def initialize(err)
      @err = REXML::Document.new(err.response.body).root
    end

   #.......................................................................................................
    def code
      @err.elements.to_a('Code').first.text      
    end

    #.......................................................................................................
    def message
      @err.elements.to_a('Message').first.text      
    end

    #.......................................................................................................
    def print
      @err.nil? ? '' : "#{code}: #{message}"
    end

  #RequestError 
  end 


#Synaptic4r
end
