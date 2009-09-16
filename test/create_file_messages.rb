#########################################################################################################
module CreateFileMessages

  #......................................................................................................
  @oid, @date = 'FILEOID', "Thu, 10 Sep 2009 17:34:30 GMT"

  ####---------------------------------------------------------------------------------------------------
  class << self

    #......................................................................................................
    attr_reader :oid, :date, :full_payload, :partial_payload
    attr_accessor :response_method

    #......................................................................................................
    def namespace_request(args)
      full_payload = IO.read(args[:file])
      full_content_md5 = Base64.encode64(Digest::MD5.digest(full_payload)).chomp()
      {:url          => "#{args[:site]}/namespace/#{args[:rpath]}",
       :http_request => :post,
       :headers      => {'content-length' => 463,
                         'content-md5'    => full_content_md5,
                         'content-type'   => 'application/octet-stream'},
       :payload      => full_payload}
    end

    #......................................................................................................
    def listable_metadata_request(args)
      full_payload = IO.read(args[:file])
      full_content_md5 = Base64.encode64(Digest::MD5.digest(full_payload)).chomp()
      {:url          => "#{args[:site]}/objects",
       :http_request => :post,
       :headers      => {'content-length'      => 463,
                         'content-md5'         => full_content_md5,
                         'x-emc-listable-meta' => args[:listable_meta],
                         'content-type'        => 'application/octet-stream'},
       :payload      => full_payload}
    end

    #......................................................................................................
    def response(args)
      send(response_method, args) if respond_to?(response_method)
    end

    #......................................................................................................
    def file_response(args)
      HttpMessages::Result.new(:headers=> {:x_emc_delta    =>   463,
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
