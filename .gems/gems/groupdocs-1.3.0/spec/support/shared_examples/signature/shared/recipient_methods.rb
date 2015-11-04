shared_examples_for GroupDocs::Signature::RecipientMethods do

  describe '#recipients!' do
    before(:each) do
      mock_api_server(load_json('template_get_recipients'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.recipients!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Recipient objects' do
      recipients = subject.recipients!
      recipients.should be_an(Array)
      recipients.each do |recipient|
        recipient.should be_a(GroupDocs::Signature::Recipient)
      end
    end
  end

  describe '#remove_recipient!' do
    let(:recipient) do
      GroupDocs::Signature::Recipient.new
    end

    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove_recipient!(recipient, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if recipient is not GroupDocs::Signature::Recipient object' do
      lambda { subject.remove_recipient!('Recipient') }.should raise_error(ArgumentError)
    end
  end
end
