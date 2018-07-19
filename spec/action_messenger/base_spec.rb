RSpec.describe ActionMessenger::Base do

  describe 'self#method_missing' do
    context 'if method_name in action_methods' do
      before do
        allow(ActionMessenger::Base).to receive(:action_methods).and_return(%w(sample))
      end

      it 'return ActionMessenger::MessageDelivery instance' do
        expect(ActionMessenger::Base.sample).to be_a(ActionMessenger::MessageDelivery)
      end
    end

    context 'if not method_name in action_methods' do
      it 'raise NoMethodError' do
        expect{ ActionMessenger::Base.sample }.to raise_error (NoMethodError)
      end
    end
  end

  describe 'self#respond_to_missing?' do
    context 'if method in action_methods' do
      before do
        allow(ActionMessenger::Base).to receive(:action_methods).and_return(%w(sample))
      end

      it 'return true' do
        expect(ActionMessenger::Base.respond_to?(:sample)).to be true
      end
    end
  end

  describe '#message_to_slack' do
    let(:base) { ActionMessenger::Base.new }

    before do
      slack_mock = double('Slack')
      allow(slack_mock).to receive(:message)
      allow(base).to receive(:slack_client).and_return(slack_mock)
    end

    it 'no exception occurs' do
      expect { base.message_to_slack(channel: 'foo') }.to_not raise_error
    end
  end

end
