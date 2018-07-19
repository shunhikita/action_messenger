require 'active_job'

module ActionMessenger
  class MessageDeliveryJob < ActiveJob::Base
    queue_as :messengers

    def perform(delivery_class_name, delivery_action, messenger_class, method_name, *args)
      delivery_class_name.constantize.new(messenger_class.constantize, method_name.to_sym, *args).public_send(delivery_action.to_sym)
    end

  end
end