###########################################################################################################
module Synaptic4r

  ###########################################################################################################
  module Utils
      
    #.......................................................................................................
    def unary_args_given?(unary_args, args)
      unary_args.each{|a| raise ArgumentError, "Required argument '#{a}' is missing." unless args.include?(a)}
    end
    
    #.......................................................................................................
    def symbolize(e)
      if e.kind_of?(Hash)
        e.inject({}){|h, (k,v)| h.update(k.to_sym => v)}
      elsif e.kind_of?(Array)
        e.map{|v| v.to_sym}
      end
    end

    #.......................................................................................................
    def create_timestamp()
      Time.now().httpdate()
    end

    #.......................................................................................................
    def read_file(file, offset, length)
      IO.read(file, length, offset)
    end

  #### Utils
  end

  ###########################################################################################################
  module Rest
    
    #------------------------------------------------------------------------------------------------------
    class << self

      def included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end

    #### self
    end


    ####-----------------------------------------------------------------------------------------------------
    module ClassMethods
    
      #.......................................................................................................
      @@method_defs = Hash.new{|h,k| h[k] = {:required => [], :optional => []}}
      @@arg_defs = Hash.new{|h,k| h[k] = {}}

      #.......................................................................................................
      def method_defs
        @@method_defs
      end

      #.......................................................................................................
      def arg_defs
        @@arg_defs
      end

      #.......................................................................................................
      def define_rest_method(meth, args)
        [meth].flatten.each do |m|
          method_defs[m][:required] += args[:required] if args[:required]
          method_defs[m][:optional] += args[:optional] if args[:optional]
          method_defs[m][:http_method] = args[:http_method]
          method_defs[m][:desc] = args[:desc]
          method_defs[m][:result_class] = args[:result_class]
          method_defs[m][:query] = args[:query]
          method_defs[m][:exe] = args[:exe]
          method_defs[m][:map_required_args] = args[:map_required_args]
          method_defs[m][:banner] = args[:banner]
        end  
      end

      #.......................................................................................................
      def define_rest_arg(arg, opts)
        arg_defs[arg].update(opts)
      end

      #.......................................................................................................
      def args
        method_defs
      end

      #.......................................................................................................
      def has_rest_method?(meth)
       rest_methods.include?(meth)
      end

      #.......................................................................................................
      def rest_methods
        args.keys.inject([]){|r,m| m.eql?(:all) ? r : r << m}
      end
      #.......................................................................................................
      def http_method(meth)
        args[meth][:http_method]
      end

      #.......................................................................................................
      def required_rest_args(meth)
        args[meth][:required] + args_all_methods(:required) 
      end

      #.......................................................................................................
      def unary_rest_args(meth)
        args[meth][:required].inject([]){|r,a| a.kind_of?(Array) ?  r : r << a}
      end

      #.......................................................................................................
      def exclusive_rest_args(meth)
        args[meth][:required].inject([]){|r,a| a.kind_of?(Array) ? r << a : r}
      end

      #.......................................................................................................
      def optional_rest_args(meth)
        args[meth][:optional] + args_all_methods(:optional)
      end

      #.......................................................................................................
      def rest_arg(arg)
        arg_defs[arg]
      end

      #.......................................................................................................
      def args_all_methods(type)
        args[:all][type].inject([]){|r,a| rest_arg(a)[:header].eql?(:hide) ? r : r << a}
      end

      #.......................................................................................................
      def desc(meth)
        args[meth][:desc]
      end

      #.......................................................................................................
      def exe(meth)
        args[meth][:exe]
      end

      #.......................................................................................................
      def banner(meth)
        args[meth][:banner]
      end

      #.......................................................................................................
      def map_required_args(meth)
        args[meth][:map_required_args]
      end

      #.......................................................................................................
      def result_class(meth)
        args[meth][:result_class]
      end

      #.......................................................................................................
      def query(meth)
        args[meth][:query]
      end

      #.......................................................................................................
      def header_args(meth)
        unary_rest_args(meth) + exclusive_rest_args(meth).flatten + optional_rest_args(meth) - 
          non_header_args(meth)
      end

      #.......................................................................................................
      def emc_headers
        arg_defs.inject([]){|r, (a, d)| d[:header].eql?(:emc) ? r.push(a) : r}
      end

      #.......................................................................................................
      def non_header_args(meth)
        arg_defs.inject([]){|r, (a, d)| d[:header].eql?(:none) ? r.push(a) : r}
      end

    #### ClassMethods
    end

    ####-----------------------------------------------------------------------------------------------------
    module InstanceMethods

      #.......................................................................................................
      include Utils
    
      #.......................................................................................................
      attr_reader :headers, :uid, :key, :site, :subtenant, :payload, :meth, :sign

      #.......................................................................................................
      def initialize(args)
        unary_args_given?([:uid, :subtenant, :key, :site], args)
        @uid = args[:uid]
        @key = args[:key]
        @site = args[:site]
        @subtenant = args[:subtenant]
        @headers = credentials
      end

      #.......................................................................................................
      def execute(meth, *args, &blk)
        @meth = meth
        args = args.first || {}
        set_remote_file(args)
        unary_args_given?(self.class.unary_rest_args(meth), args)
        exclusive_args_given?(self.class.exclusive_rest_args(meth), args)
        self.class.exe(meth)[self, args] if self.class.exe(meth)
        build_service_url(args)
        add_header_attr(args)
        create_signature
        res = if args[:dump].nil? and args[:payload].nil?                
                RestClient::Request.execute(:method => self.class.http_method(meth), :url => site, 
                                            :headers => headers, :payload => payload)
              else; nil; end
        self.class.result_class(meth).new(:result => res, :headers => headers, :url => site, :sign => sign,
                                          :http_request => self.class.http_method(meth), 
                                          :payload => args[:payload] ? payload : nil)
      end

      #.......................................................................................................
      def exclusive_args_given?(exclusive_args, args)
        exclusive_args.each do |alist| 
          unless alist.select{|a| args.keys.include?(a)}.length.eql?(1)
            acli = alist.map{|a| [self.class.rest_arg(a)[:cli]].flatten.first}
            raise ArgumentError, "One of '#{acli.join(', ')}' is required as an argument."
          end
        end
      end

      #.......................................................................................................
      def add_header_attr(given={})
        to_emc = lambda{|a| h = a.to_s.gsub(/_/,'-'); self.class.emc_headers.include?(a) ? "x-emc-#{h}" : h}
        header_args = self.class.header_args(meth)
        given.keys.each do |k| 
          headers.update(to_emc[k] => given[k]) if header_args.include?(k)
        end
      end


      #.......................................................................................................
      def set_remote_file(args)
        if args[:rpath]
          if args[:namespace]
            args[:rpath] = args[:namespace] + '/' + args[:rpath]
          else
            args[:rpath] = uid + '/' + args[:rpath]
          end
        end
      end

      #.......................................................................................................
      def build_service_url(args={})
        surl = if args[:rpath]
                 'namespace/' + args[:rpath]
               else
                 'objects' + (args[:oid].nil? ? '' : "/#{args[:oid]}")
               end
        @site = (/\/$/.match(site).nil? ? site + '/' : site) + surl + 
          ((q = self.class.query(meth)).nil? ? '' : "?#{q}")
      end

      #.......................................................................................................
      def create_signature
        @sign = create_sign_string
        digest = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), Base64.decode64(key), sign)
        headers['x-emc-signature'] = Base64.encode64(digest.to_s()).chomp()
      end

      #.......................................................................................................
      def create_sign_string
        composite_string = (self.class.http_method(meth).to_s.upcase  || '') + "\n" + \
                           (headers['content-type']                   || '') + "\n" + \
                           (headers['range']                          || '') + "\n" + \
                           (headers['date']                           || '') + "\n"
        if site
          composite_string += URI.parse(site).path.downcase
          composite_string += "?" + URI.parse(site).query.downcase unless URI.parse(site).query.nil?
        end
        composite_string += "\n" +  canonicalize_custom_headers
      end

      #.......................................................................................................
      def canonicalize_custom_headers
        headers.select do |key, value| 
          /^x-emc-/.match(key)
        end.sort.inject("") do |h, (k, v)|
          h += "#{k}:#{v}\n"
        end.chomp
      end

      #.......................................................................................................
      def set_header_range(args, ext)
        if args[:file]
          headers['range'] = "bytes=#{ext[:offset]}-#{ext[:offset]+ext[:length]-1}"
        end
      end

      #.......................................................................................................
      def extent(file, begin_offset, end_offset)
        if file
          file_offset = File.size(file) - 1
          offset =  begin_offset.to_i
          end_offset = end_offset.nil? ? file_offset : end_offset.to_i 
          end_offset = file_offset if end_offset > file_offset
          length = end_offset - offset + 1
          {:offset => offset, :length => length}
        end
      end

      #.......................................................................................................
      def set_header_extent(args, ext)
        if args[:file]
          args[:beginoffset] = ext[:offset]
          args[:endoffset] = ext[:offset] + ext[:length] - 1 
        end
      end

      #.......................................................................................................
      def add_payload(args, ext)
        if args[:file]
          @payload = read_file(args[:file], ext[:offset], ext[:length])
          if @payload
            headers['content-length'] = ext[:length]
            headers['content-md5'] = Base64.encode64(Digest::MD5.digest(payload)).chomp()
          end
        end
      end

      #.......................................................................................................
      def credentials
        curr_time = create_timestamp
        {'x-emc-uid'    => subtenant + '/' + uid, 
         'date'         => curr_time, 
         'x-emc-date'   => curr_time, 
         'content-type' => 'application/octet-stream',
         'accept'       => '*/*'}
      end

    #### InstanceMethods
    end

     
  ### Rest 
  end

#### Synaptic4r
end
