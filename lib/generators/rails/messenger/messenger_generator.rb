require 'rails'

module Rails
  module Generators
    class MessengerGenerator < NamedBase
      source_root File.expand_path("templates", __dir__)

      argument :actions, type: :array, default: [], banner: 'method method'

      check_class_collision suffix: 'Messenger'

      def create_messenger_file
        template 'messenger.rb', File.join('app/messengers', class_path, "#{file_name}_messenger.rb")

        in_root do
          if behavior == :invoke && !File.exist?(application_messenger_file_name)
            template 'application_messenger.rb', application_messenger_file_name
          end
        end
      end

      def create_messenger_view_file
        actions.each do |action|
          template 'messenger_template.rb',  File.join('app/views', class_path,"#{file_name}_messengers", "#{action}.text.erb")
        end
      end

      private

      def file_name
        @_file_name ||= super.sub(/_messenger\z/i, '')
      end

      def application_messenger_file_name
        @_application_messenger_file_name ||= if mountable_engine?
                                                "app/messengers/#{namespaced_path}/application_messenger.rb"
                                              else
                                                'app/messengers/application_messenger.rb'
                                              end
      end

    end
  end
end
