require 'active_support/log_subscriber'

module ActionMessenger
  class LogSubscriber < ActiveSupport::LogSubscriber

    def deliver_now!(event)
      info do
        "#{Time.current} Sent Message (#{event.duration.round(1)}ms) #{event.payload.as_json}"
      end
    end

    def message_to_slack(event)
      info do
        "#{Time.current} Sent Message to Slack (#{event.duration.round(1)}ms) #{event.payload.as_json}"
      end
    end

    def logger
      ActionMessenger::Base.logger
    end

  end
end

ActionMessenger::LogSubscriber.attach_to :action_messenger
