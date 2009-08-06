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
    attr_reader :uid, :key, :site, :resource, :subtenant, :account
  
    #.........................................................................................................
    def initialize(args = nil)
      config_params = %w(key site subtenant uid)
      if args
        if args[:account]
          @account = args[:account]
          raise ArgumentError, "Account '#{account}' not found in #{ENV['HOME']}/.synaptic4r" unless config[account]
          args.update(symbolize(config[account]))
        end
      else
        if config_params.eql?(config.keys.sort)
          args = symbolize(config)
        elsif config[config.keys.first].kind_of?(Hash) and config_params.eql?(config[config.keys.first].keys.sort)
          @account = config.keys.first
          args = symbolize(config[account])
        else
          raise ArgumentError, "#{ENV['HOME']}/.synaptic4r unreadable"
        end
      end
      unary_args_given?(symbolize(config_params), args.keys)
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

  private

    #.........................................................................................................
    def config
      @config ||= File.open(Client.config_file){|yf| YAML::load(yf)}
    end

  #### Client
  end

#### Synaptic4r
end
