####-----------------------------------------------------------------------------------------------------
module Synaptic4r
  
  ####------------------------------------------------------------------------------------------------------
  class Client
    

    ####------------------------------------------------------------------------------------------------------
    include Utils

    #.........................................................................................................
    @config_file = ENV['HOME'] + '/.synaptic4r'

    ####------------------------------------------------------------------------------------------------------
    class << self
      attr_reader :config_file
    end

    #.........................................................................................................
    attr_reader :uid, :key, :site, :resource, :subtenant
  
    #.........................................................................................................
    def initialize(args = nil)
      args ||= symbolize(File.open(Client.config_file){|yf| YAML::load(yf)})
      unary_args_given?([:uid, :key, :site, :subtenant], args)
      @subtenant = args[:subtenant]
      @uid = args[:uid]
      @key = args[:key]
      @site = args[:site]      
    end

    #.........................................................................................................
    def method_missing(meth, *args, &blk)
      if Request.has_rest_method?(meth)
        Request.new(:uid => uid, :subtenant => subtenant, :key => key, :site => site).execute(meth, *args, &blk)
      else
        super
      end
    end

  #### Client
  end

#### Synaptic4r
end
