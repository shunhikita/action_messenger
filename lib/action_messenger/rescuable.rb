module ActionMessenger
  module Rescuable
    extend ActiveSupport::Concern
    include ActiveSupport::Rescuable

    # call rescue_from when an exception occurs
    def handle_exceptions
      yield
    rescue => e
      rescue_with_handler(e) || raise(e)
    end

  end
end
