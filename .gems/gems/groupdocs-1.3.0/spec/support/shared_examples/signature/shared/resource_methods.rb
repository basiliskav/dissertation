shared_examples_for GroupDocs::Signature::ResourceMethods do

  describe '.resources!' do
    before(:each) do
      mock_api_server(load_json('envelopes_resources'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.resources!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      lambda { described_class.resources!(:status_ids => %w(sdfj943fjof043fj)) }.should_not raise_error(ArgumentError)
    end

    it 'returns resources hash' do
      described_class.resources!.should be_a(Hash)
    end

    it 'returns hash with documents as array of GroupDocs::Document objects' do
      documents = described_class.resources![:documents]
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end

    it 'returns hash with recipients as array of GroupDocs::Signature::Recipient objects' do
      recipients = described_class.resources![:recipients]
      recipients.should be_an(Array)
      recipients.each do |recipient|
        recipient.should be_a(GroupDocs::Signature::Recipient)
      end
    end

    it 'returns hash with other values as array of strings' do
      dates = described_class.resources![:dates]
      dates.should be_an(Array)
      dates.each do |date|
        date.should be_a(String)
      end
    end
  end
end
