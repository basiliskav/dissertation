shared_examples_for GroupDocs::Signature::DocumentMethods do

  describe '#documents!' do
    before(:each) do
      mock_api_server(load_json('template_get_documents'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.documents!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Document objects' do
      documents = subject.documents!
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end
  end

  describe '#add_document!' do
    let(:document) do
      GroupDocs::Document.new(:file => GroupDocs::Storage::File.new)
    end

    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_document!(document, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.add_document!(document, :order => 1)
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if document is not GroupDocs::Document object' do
      lambda { subject.add_document!('Document') }.should raise_error(ArgumentError)
    end
  end

  describe '#remove_document!' do
    let(:document) do
      GroupDocs::Document.new(:file => GroupDocs::Storage::File.new)
    end

    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove_document!(document, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if document is not GroupDocs::Document object' do
      lambda { subject.remove_document!('Document') }.should raise_error(ArgumentError)
    end
  end
end
