shared_examples_for GroupDocs::Signature::EntityMethods do

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json("#{subject.send(:class_name)}_get"))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!("j5498fre9fje9f", :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it "returns #{described_class} objects" do
      described_class.get!("j5498fre9fje9f").should be_a(described_class)
    end
  end

  # GroupDocs::Signature::Form overwrites #create! so we should not run default specs for it
  unless described_class == GroupDocs::Signature::Form
    describe '#create!' do
      before(:each) do
        mock_api_server(load_json("#{subject.send(:class_name)}_get"))
      end

      it 'accepts access credentials hash' do
        lambda do
          subject.create!({}, :client_id => 'client_id', :private_key => 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'accepts options hash' do
        lambda do
          subject.create!(:template_id => 'aodfh43yr9834hf943h')
        end.should_not raise_error(ArgumentError)
      end

      it 'uses hashed version of self as request body' do
        subject.should_receive(:to_hash)
        subject.create!
      end

      it 'updates identifier of entity' do
        lambda do
          subject.create!
        end.should change(subject, :id)
      end
    end
  end

  describe '#modify!' do
    before(:each) do
      mock_api_server(load_json("#{subject.send(:class_name)}_get"))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.modify!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.modify!
    end
  end

  describe '#rename!' do
    before(:each) do
      mock_api_server(%({ "status": "Ok", "result": { "#{subject.send(:class_name)}": null }}))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.rename!('Name', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    # alter params for form
    if described_class == GroupDocs::Signature::Form
      it 'uses new_name as parameter' do
        api = stub(GroupDocs::Api::Request)
        api.stub!(:execute! => {})
        GroupDocs::Api::Request.stub(:new => api)
        api.should_receive(:add_params).with(:new_name => 'Name')
        subject.rename!('Name')
      end
    else
      it 'uses name as parameter' do
        api = stub(GroupDocs::Api::Request)
        api.stub!(:execute! => {})
        GroupDocs::Api::Request.stub(:new => api)
        api.should_receive(:add_params).with(:name => 'Name')
        subject.rename!('Name')
      end
    end

    it 'updates name of template' do
      lambda do
        subject.rename!('Name')
      end.should change(subject, :name)
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server(%({ "status": "Ok", "result": { "#{subject.send(:class_name)}": null }}))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
