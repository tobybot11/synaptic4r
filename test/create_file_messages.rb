#########################################################################################################
module CreateFileMessages

  #......................................................................................................
  @oid, @date = 'FILEOID', "Thu, 10 Sep 2009 17:34:30 GMT"

  ####---------------------------------------------------------------------------------------------------
  class << self

    #......................................................................................................
    attr_reader :oid, :date, :payload
    attr_accessor :response_method

    #......................................................................................................
    def namespace_request(args)
      payload = args[:file].kind_of?(String) ? IO.read(args[:file]) : (args[:file].rewind; args[:file].read)
      size = payload.length
      content_md5 = Base64.encode64(Digest::MD5.digest(payload)).chomp()
      {:url          => "#{args[:site]}/namespace/#{args[:rpath]}",
       :http_request => :post,
       :headers      => {'content-length' => size,
                         'content-md5'    => content_md5,
                         'content-type'   => 'application/octet-stream'},
       :payload      => payload}
    end

    #......................................................................................................
    def namespace_partial_request(args)
      size = args[:create_endoffset] - args[:create_beginoffset] + 1
      payload = if args[:file].kind_of?(String)
                  IO.read(args[:file], length, args[:create_beginoffset])
                else
                  args[:file].rewind; args[:file].seek(args[:create_beginoffset]); args[:file].read(size)
                end
      content_md5 = Base64.encode64(Digest::MD5.digest(payload)).chomp()
      {:url          => "#{args[:site]}/namespace/#{args[:rpath]}",
       :http_request => :post,
       :headers      => {'content-length' => size,
                         'content-md5'    => content_md5,
                         'content-type'   => 'application/octet-stream'},
       :payload      => payload}
    end

    #......................................................................................................
    def listable_metadata_request(args)
      payload = IO.read(args[:file])
      size = payload.length
      content_md5 = Base64.encode64(Digest::MD5.digest(payload)).chomp()
      {:url          => "#{args[:site]}/objects",
       :http_request => :post,
       :headers      => {'content-length'      => size,
                         'content-md5'         => content_md5,
                         'x-emc-listable-meta' => args[:listable_meta],
                         'content-type'        => 'application/octet-stream'},
       :payload      => payload}
    end

    #......................................................................................................
    def response(args)
      send(response_method, args) if respond_to?(response_method)
    end

    #......................................................................................................
    def file_response(args)
      HttpMessages::Result.new(:headers=> {:x_emc_delta    =>   size,
                                           :date           =>   date,
                                           :content_type   =>   "text/plain; charset=UTF-8", 
                                           :location       =>   "/rest/objects/#{oid}"},
                               :body    => '')
    end 

    #......................................................................................................
    def file_offset_response(args)
      HttpMessages::Result.new(:headers=> {:x_emc_delta    =>   args[:endoffset]-args[:beginoffset]+1, 
                                           :date           =>   date,
                                           :content_type   =>   'text/plain; charset=UTF-8', 
                                           :location       =>   "/rest/objects/#{oid}"},
                               :body    => '')
    end

  #### self
  end

### HttpMessages
end
