RSpec.describe ActionMessenger::MessageDelivery do

  describe '#deliver_now!' do
    context 'when args is exist' do
      let(:delivery) { ActionMessenger::MessageDelivery.new(ActionMessenger::Base, :sample, 'foo') }

      before do
        ActionMessenger::Base.define_method :sample do |args| args end
      end

      it 'no exception occurs' do
        expect{ delivery.deliver_now! }.to_not raise_error
      end

    end

    context 'when args is empty' do
      let(:delivery) { ActionMessenger::MessageDelivery.new(ActionMessenger::Base, :sample) }

      before do
        ActionMessenger::Base.define_method :sample do end
      end

      it 'no exception occurs' do
        expect { delivery.deliver_now! }.to_not raise_error
      end
    end
  end

  describe '#deliver_later!' do

    let(:messenger) { ActionMessenger::Base.new }
    let(:delivery) { ActionMessenger::MessageDelivery.new(ActionMessenger::Base.new, :sample) }

    before do
      ActionMessenger::Base.define_method :sample do end
    end

    it 'no exception occurs' do
      expect { delivery.deliver_later! }.to_not raise_error
    end

  end

end
