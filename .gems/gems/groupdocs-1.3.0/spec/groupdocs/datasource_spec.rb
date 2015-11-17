require 'spec_helper'

describe GroupDocs::DataSource do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('datasource_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(1, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.get!(1, :field => %w(field1 field2))
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::DataSource object if datasource is found' do
      described_class.get!(1).should be_a(GroupDocs::DataSource)
    end

    it 'returns nil if ResourceNotFound was raised' do
      GroupDocs::Api::Request.any_instance.should_receive(:execute!).and_raise(RestClient::ResourceNotFound)
      described_class.get!(99).should be_nil
    end
  end

  it { should have_accessor(:id)               }
  it { should have_accessor(:descr)            }
  it { should have_accessor(:questionnaire_id) }
  it { should have_accessor(:created_on)       }
  it { should have_accessor(:modified_on)      }
  it { should have_accessor(:fields)           }

  it { should alias_accessor(:description, :descr) }

  describe '#created_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.created_on = 1332950825000
      subject.created_on.should == Time.at(1332950825)
    end
  end

  describe '#modified_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.modified_on = 1332950825000
      subject.modified_on.should == Time.at(1332950825)
    end
  end

  describe '#fields=' do
    it 'converts each field to GroupDocs::DataSource::Field object if hash is passed' do
      subject.fields = [{ :name => 'field1', :values => %w(value1 value2), :type => 1 }]
      fields = subject.fields
      fields.should be_an(Array)
      fields.each do |field|
        field.should be_a(GroupDocs::DataSource::Field)
      end
    end

    it 'saves each field if it is GroupDocs::DataSource::Field object' do
      field1 = GroupDocs::DataSource::Field.new(:name => 'field1')
      field2 = GroupDocs::DataSource::Field.new(:name => 'field2')
      subject.fields = [field1, field2]
      subject.fields.should include(field1)
      subject.fields.should include(field2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.fields = nil
      end.should_not change(subject, :fields)
    end
  end

  describe '#add_field' do
    it 'raises error if field is not GroupDocs::DataSource::Field object' do
      lambda { subject.add_field('Field') }.should raise_error(ArgumentError)
    end

    it 'saves field' do
      field = GroupDocs::DataSource::Field.new
      subject.add_field(field)
      subject.fields.should == [field]
    end
  end

  describe '#add!' do
    before(:each) do
      mock_api_server(load_json('datasource_add'))
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

    it 'updates identifier of datasource' do
      lambda do
        subject.add!
      end.should change(subject, :id)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('datasource_update'))
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

  describe '#remove!' do
    before(:each) do
      mock_api_server(load_json('datasource_remove'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
