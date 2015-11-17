require 'spec_helper'

describe GroupDocs::Signature::List do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('lists_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::List objects' do
      lists = described_class.get!
      lists.should be_an(Array)
      lists.each do |list|
        list.should be_a(GroupDocs::Signature::List)
      end
    end
  end

  it { should have_accessor(:id)           }
  it { should have_accessor(:name)         }
  it { should have_accessor(:values)       }
  it { should have_accessor(:defaultValue) }

  it { should alias_accessor(:default_value, :defaultValue) }

  describe '#values=' do
    it 'converts array of values to a string' do
      subject.values = %w(Test1 Test2)
      subject.instance_variable_get(:@values).should == 'Test1;Test2'
    end

    it 'does nothing if values is a string' do
      subject.values = 'Test1;Test2'
      subject.instance_variable_get(:@values).should == 'Test1;Test2'
    end
  end

  describe '#values' do
    it 'returns values as an array' do
      subject.values = 'Test1;Test2'
      subject.values.should == %w(Test1 Test2)
    end
  end

  describe '#add!' do
    before(:each) do
      mock_api_server(load_json('list_add'))
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

    it 'updates identifier of list' do
      lambda do
        subject.add!
      end.should change(subject, :id)
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": { "list": null }}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
