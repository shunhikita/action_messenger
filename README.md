# ActionMessenger

Framework for delivering messages to Messenger. Currently only slack is supported.

:warning: **This is highly experimental project. Current version is 0.1.0**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_messenger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_messenger

## Configuration

```rb
 ActionMessenger.configure do |config|
   config.slack_api_token = ENV['SLACK_API_TOKEN']  # for slack
   config.views_path = "/app/views" #default: Rails.root.join("app","views")
   config.logger = Logger.new("your_log_path") # default: Rails.logger
end
```

## Generation

### Rails

```
bundle exec rails generate messenger account registerd_notify removed_notify

# create  app/messengers/account_messenger.rb
# create  app/messengers/application_messenger.rb
# create  app/views/account_messengers/registerd_notify.text.erb
# create  app/views/account_messengers/removed_notify.text.erb 
```


## Usage

```rb
class AccountMessenger < ApplicationMessenger 

  def registered_notify(registered_accout_id)
    @account = Account.find(registered_account)
    message_to_slack(channel: "#account-registerd-notice")
  end

end

AccountMessenger.registerd_notify(@account.id).deliver_now!
# or
AccountMessenger.registerd_notify(@account.id).deliver_later! # for active job
```

### Handle exception

```rb
class AccountMessenger < ApplicationMessenger

  rescue_from Exception, with: -> { }
  rescue_from HogeError, with: -> { }

end
```

## Send messages

In the instance method of the class inheriting ActionMessenger::Base, the following methods can be used.

### Message to Slack

```rb
# When the text option is specified, it becomes a message, and if not specified, the contents of the corresponding View template becomes a message.
message_to_slack(channel: '#sample', options: {text: 'hogehoge'})
# You can also specify attachments.
message_to_slack(channel: '#sample', options: {attachments: [{"pretext": "pre-hello", "text": "text-world"}]})
# And other options.
# -> https://api.slack.com/methods/chat.postMessage
```

### File upload to Slack

```rb
upload_file_to_slack(channels: '#general',file: Faraday::UploadIO.new('/path/to/sample.jpg', 'image/jpg'), options: {})
# And other options.
# -> https://api.slack.com/methods/files.upload
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/action_messenger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
