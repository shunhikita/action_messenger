module ActionMessenger

  class << self
    def configure
      yield config
    end

    def config
      @config ||= ActionMessenger::Config.new
    end
  end

  class Config
    include ActiveSupport::Configurable
    config_accessor :slack_api_token
    config_accessor :views_path
    config_accessor :logger
  end

end
