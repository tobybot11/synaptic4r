#########################################################################################################
module HttpMessages

  
  ####---------------------------------------------------------------------------------------------------
  class Body

    #......................................................................................................
    attr_reader :body

    #......................................................................................................
    def initialize(args)
      @body = args
    end

  #### Result
  end

  ####---------------------------------------------------------------------------------------------------
  class Result

    #......................................................................................................
    attr_reader :headers, :net_http_res

    #......................................................................................................
    def initialize(args)
      @headers = args[:headers]
      @net_http_res = Body.new(args[:body])
    end

  #### Result
  end


  ####---------------------------------------------------------------------------------------------------
  class << self

    #......................................................................................................
    # create messages
    #......................................................................................................
    def create_dir_request(args)
      {:url          => "#{args[:site]}/namespace/#{args[:rpath]}",
       :http_request => :post,
       :payload      => nil}
    end

    #......................................................................................................
    def create_dir_response(args)
      Result.new(:headers=> {:x_emc_delta=>    "0", 
                             :date=>           "Thu, 10 Sep 2009 17:34:30 GMT",
                             :content_type=>   "text/plain; charset=UTF-8", 
                             :content_length=> "0", 
                             :location=>       "/rest/objects/DIROID"},
                 :body => '')
    end

  #### self
  end

### HttpMessages
end