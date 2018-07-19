require 'action_messenger/version'

require 'active_support'
require 'abstract_controller'
require 'action_view'
require 'action_messenger/config'

if defined?(Rails)
  require 'action_messenger/railtie'
end

module ActionMessenger
  extend ::ActiveSupport::Autoload

  autoload :Base
  autoload :MessageDelivery
  autoload :MessageDeliveryJob

  module Providers
    require 'action_messenger/providers/slack'
  end
end
