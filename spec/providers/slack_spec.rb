RSpec.describe ActionMessenger::Providers::Slack do

  describe '#message' do
    let (:slack) { ActionMessenger::Providers::Slack.new }

    before do
      ActionMessenger.config.slack_api_token = 'dummy'
      allow(slack.client).to receive(:chat_postMessage).and_return('sample')
    end

    it 'no exception occurs' do
      expect{ slack.message('#dummy-channel', {text: 'sample'}) }.to_not raise_error
    end

    it 'Slack::Web::Client#chat_postmessage to be called' do
      slack.message('#dummy-channel', {text: 'sample'})
      expect(slack.client).to have_received(:chat_postMessage).once
    end

  end

end