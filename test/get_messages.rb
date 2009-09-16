#########################################################################################################
module GetMessages

  #......................................................................................................
  @date = "Thu, 10 Sep 2009 17:34:30 GMT"

  @get_dir_result =[{:objectid=>'OID1', :filetype=>'directory', :filename=>'lib'},
                    {:objectid=>'OID2', :filetype=>'regular',   :filename=>'file1.rb'},
                    {:objectid=>'OID3', :filetype=>'regular',   :filename=>'file2.rb'}]

  @get_dir_body = <<-BODY
                    <?xml version='1.0' encoding='UTF-8'?>
                    <ListDirectoryResponse xmlns='http://www.emc.com/cos/'>
                      <DirectoryList>
                        <DirectoryEntry>
                          <ObjectID>#{@get_dir_result[0][:objectid]}</ObjectID>
                          <FileType>#{@get_dir_result[0][:filetype]}</FileType>
                          <Filename>#{@get_dir_result[0][:filename]}</Filename>
                        </DirectoryEntry>
                        <DirectoryEntry>
                          <ObjectID>#{@get_dir_result[1][:objectid]}</ObjectID>
                          <FileType>#{@get_dir_result[1][:filetype]}</FileType>
                          <Filename>#{@get_dir_result[1][:filename]}</Filename>
                        </DirectoryEntry>
                        <DirectoryEntry>
                          <ObjectID>#{@get_dir_result[2][:objectid]}</ObjectID>
                          <FileType>#{@get_dir_result[2][:filetype]}</FileType>
                          <Filename>#{@get_dir_result[2][:filename]}</Filename>
                        </DirectoryEntry>
                      </DirectoryList>
                    </ListDirectoryResponse>
                  BODY

  ####---------------------------------------------------------------------------------------------------
  class << self

    #......................................................................................................
    attr_reader :date, :get_dir_body, :get_dir_result, :get_dir_oid
    attr_accessor :response_method

    #......................................................................................................
    def response(args)
      send(response_method, args) if respond_to?(response_method)
    end

    #......................................................................................................
    # get directory messages
    #......................................................................................................
    def dir_namespace_request(args)
      {:url          => "#{args[:site]}/namespace/#{args[:rpath]}",
       :http_request => :get,
       :headers      => {'content-type'   => 'application/octet-stream'},
       :payload      => nil}
    end

    #......................................................................................................
    def dir_objects_request(args)
      {:url          => "#{args[:site]}/objects/#{args[:oid]}",
       :http_request => :get,
       :headers      => {'content-type'   => 'application/octet-stream'},
       :payload      => nil}
    end

    #......................................................................................................
    def dir_response(args)
      HttpMessages::Result.new(:headers => {:content_type=> "text/xml"}, 
                               :body    => get_dir_body)
    end

    #......................................................................................................
    # get file messages
    #......................................................................................................
    def file_namespace_request(args)
      {:url          => "#{args[:site]}/namespace/#{args[:rpath]}",
       :http_request => :get,
       :headers      => {'content-type'   => 'application/octet-stream'},
       :payload      => nil}
    end

    #......................................................................................................
    def file_namespace_with_offset_request(args)
      {:url          => "#{args[:site]}/namespace/#{args[:rpath]}",
       :http_request => :get,
       :headers      => {'endoffset'    => args[:endoffset], 
                         'beginoffset'  => args[:beginoffset],
                         'range'        =>"bytes=#{args[:beginoffset]}-#{args[:endoffset]}",
                         'content-type' => 'application/octet-stream'},
       :payload      => nil}
    end

    #......................................................................................................
    def file_objects_request(args)
      {:url          => "#{args[:site]}/objects/#{args[:oid]}",
       :http_request => :get,
       :headers      => {'content-type'   => 'application/octet-stream'},
       :payload      => nil}
    end

    #......................................................................................................
    def file_response(args)
      HttpMessages::Result.new(:headers => {:content_type=> "text/xml"}, 
                               :body    => get_dir_body)
    end


    #......................................................................................................
    def file_offset_response(args)
      HttpMessages::Result.new(:headers => {:content_type=> "text/xml"}, 
                               :body    => get_dir_body)
    end

  #### self
  end

### GetDirMessages
end
