require 'action_messenger/rescuable'
require 'action_messenger/log_subscriber'

module ActionMessenger
  class Base < AbstractController::Base

    include AbstractController::Rendering
    include AbstractController::Logger
    include AbstractController::Helpers
    include ActionView::Layouts
    include ActionMessenger::Rescuable

    class << self

      def logger
        ActionMessenger.config.logger || (defined?(Rails) ? Rails.logger : nil)
      end

      private

      def method_missing(method_name, *args)
        if action_methods.include?(method_name.to_s)
          ActionMessenger::MessageDelivery.new(self, method_name, *args)
        else
          super
        end
      end

      def respond_to_missing?(method, include_all = false)
        action_methods.include?(method.to_s) || super
      end

    end # end class << self

    attr_reader :caller_method_name, :deliveries

    DeliveryLog = Struct.new(:method, :channels, :result)

    def initialize
      @deliveries = []
    end

    # message to slack
    #
    # @param [String] channel slack channel.
    #   ex. #general
    # @param [Hash] options Slack API Request Options
    #  ex. https://api.slack.com/methods/chat.postMessage
    #
    # ex. message_to_slack(channel: '#general', options: {text: 'sample'})
    def message_to_slack(channel:, options: {})
      @caller_method_name = caller[0][/`([^']*)'/, 1]
      options = apply_defaults(options)
      message = nil
      ActiveSupport::Notifications.instrument('message_to_slack.action_messenger', channel: channel, body: options[:text]) do
        message = slack_client.message(channel, options)
      end
      message
    ensure
     self.deliveries << DeliveryLog.new(__method__, channel, message)
    end

    # upload file to slack
    #
    # @param [String] channels slack channel
    #   ex. #general, #hoge
    # @param [Faraday::UploadIO] file upload file
    #   ex. Faraday::UploadIO.new('/path/to/sample.jpg', 'image/jpg')
    # @param [Hash] options
    def upload_file_to_slack(channels: ,file: ,options: {})
      upload_file = nil
      ActiveSupport::Notifications.instrument('upload_file_to_slack.action_messenger', channels: channels) do
        upload_file = slack_client.upload_file(channels, file, options)
      end
      upload_file
    ensure
      self.deliveries << DeliveryLog.new(__method__, channels, upload_file)
    end


    private

      def apply_defaults(options)
        options[:text] = render_template_text if options[:text].blank?
        options
      end

      def render_template_text
        return '' if views_path.blank?

        lookup_context = ActionView::LookupContext.new(views_path)
        lookup_context.cache = false

        view_context = ActionView::Base.new(lookup_context)
        instance_variables.each {|name| view_context.assign(name.to_s.gsub('@', '').to_sym => instance_variable_get(name))}
      
        view_context.render(template: caller_method_name.to_s, prefixes: self.class.name.underscore.pluralize)
      end

      def views_path
        ActionMessenger.config.views_path || (defined?(Rails) ? Rails.root.join('app', 'views') : nil)
      end

      def slack_client
        ActionMessenger::Providers::Slack.new
      end

  end
end
