require 'action_messenger'
require 'rails'

module ActionMessenger
  class Railtie < Rails::Railtie
    config.action_messenger = ActiveSupport::OrderedOptions.new
    config.eager_load_namespaces << ActionMessenger
  end
end
