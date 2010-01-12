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
    attr_reader :credentials
  
    #.........................................................................................................
    def initialize(args = nil)
      config_params = %w(key site subtenant uid)
      if args
        account = args[:account]
        if account
          aconfig = config_by_account(account)
          raise ArgumentError, "Account '#{account}' not found in #{ENV['HOME']}/.synaptic4r" unless aconfig
          args.update(symbolize(aconfig))
        end
      else
        if config.kind_of?(Hash)
          args = symbolize(config)
        elsif config.kind_of?(Array)
          cfg = config.first
          args = symbolize(cfg)
        else
          raise ArgumentError, "#{ENV['HOME']}/.synaptic4r not formatted properly"
        end
      end
      unary_args_given?(symbolize(config_params), args.keys)
      @credentials= {:subtenant => args[:subtenant], :uid => args[:uid], :key => args[:key], :site => args[:site]}
    end

    #.........................................................................................................
    def method_missing(meth, *args, &blk)
      if StorageRequest.has_rest_method?(meth)
        StorageRequest.new(credentials).execute(meth, *args, &blk)
      else
        super
      end
    end

  private

    #.........................................................................................................
    def config
      @config ||= File.open(Client.config_file){|yf| YAML::load(yf)}
    end

    #.........................................................................................................
    def config_by_account(account)
      if config.kind_of?(Array)
        a = config.select{|c| c['account'].eql?(account)}.first
        a.delete('account') unless a.nil?; a
      else; config; end
    end

  #### Client
  end

#### Synaptic4r
end
