require 'spec_helper'

describe GroupDocs::Signature::Contact do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('contacts_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      lambda { described_class.get!(:page => 1, :email => 'com') }.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Contact objects' do
      contacts = described_class.get!
      contacts.should be_an(Array)
      contacts.each do |contact|
        contact.should be_a(GroupDocs::Signature::Contact)
      end
    end
  end

  describe '.import!' do
    let(:contact) do
      described_class.new(:first_name => 'John', :last_name => 'Smith', :email => 'john@smith.com')
    end

    before(:each) do
      mock_api_server(load_json('contacts_import'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.import!([contact], :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if contacts is not array' do
      lambda { described_class.import!(contact) }.should raise_error(ArgumentError)
    end

    it 'raises error if array element is not GroupDocs::Signature::Contact' do
      lambda { described_class.import!(%w(test)) }.should raise_error(ArgumentError)
    end

    it 'uses hashed version of array elements as request body' do
      contact.should_receive(:to_hash)
      described_class.import!([contact])
    end
  end

  it { should have_accessor(:id)        }
  it { should have_accessor(:firstName) }
  it { should have_accessor(:lastName)  }
  it { should have_accessor(:nickname)  }
  it { should have_accessor(:email)     }
  it { should have_accessor(:provider)  }

  it { should alias_accessor(:first_name, :firstName) }
  it { should alias_accessor(:last_name, :lastName)   }

  describe '#add!' do
    before(:each) do
      mock_api_server(load_json('contact_add'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.add!
    end

    it 'updates identifier of contact' do
      lambda do
        subject.add!
      end.should change(subject, :id)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('contact_add'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.add!
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": { "contact": null }}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
