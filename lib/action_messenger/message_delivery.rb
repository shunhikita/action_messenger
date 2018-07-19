require 'action_messenger/log_subscriber'

module ActionMessenger
  class MessageDelivery

    attr_reader :messenger_class, :method_name, :args

    def initialize(messenger_class, method_name, *args)
      @messenger_class = messenger_class
      @method_name = method_name
      @args = args
    end

    # send a message now
    def deliver_now!
      messenger.handle_exceptions do
        ActiveSupport::Notifications.instrument('deliver_now!.action_messenger', method_name: method_name, args: args) do
          if args.present?
            messenger.public_send(method_name, *args)
          else
            messenger.public_send(method_name)
          end
        end
      end
    end

    # send a message asynchronously
    def deliver_later!
      ActionMessenger::MessageDeliveryJob.perform_later(self.class.name, 'deliver_now!', messenger_class.to_s, method_name.to_s, *args)
    end

    def messenger
      @messenger ||= messenger_class.new
    end

  end
end
