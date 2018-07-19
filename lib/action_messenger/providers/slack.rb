require 'slack-ruby-client'

module ActionMessenger
  module Providers
    class Slack

      TokenError = Class.new(StandardError)

      attr_reader :client

      def initialize
        raise(TokenError.new('slack api token is blank.')) if ActionMessenger.config.slack_api_token.blank?

        @client = ::Slack::Web::Client.new.tap do |client|
          client.token = ActionMessenger.config.slack_api_token
        end
      end

      # message to slack
      # @param [String] channel
      # @param [Hash] options
      def message(channel, options)
        options = {channel: channel}.merge(message_option_to_api_hash(options))
        client.chat_postMessage(options)
      end

      private

        # @param options [Hash] Slack API Request Options
        #   ex. https://api.slack.com/methods/chat.postMessage
        def message_option_to_api_hash(options)
          raise ArgumentError('text is blank.') if options[:text].blank? && options[:attachments].blank?

          options.delete_if { |_, v| v.nil? }
        end
    end
  end
end
