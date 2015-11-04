require 'spec_helper'

describe GroupDocs::Questionnaire::Execution do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!('45dsfh9348uf0fj834y92h', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Questionnaire::Execution object' do
      described_class.get!('45dsfh9348uf0fj834y92h').should be_a(GroupDocs::Questionnaire::Execution)
    end

    it 'returns nil if BadResponseError was raised' do
      GroupDocs::Api::Request.any_instance.should_receive(:execute!).and_raise(GroupDocs::BadResponseError)
      described_class.get!('45dsfh9348uf0fj834y92h').should be_nil
    end
  end

  it { should have_accessor(:id)                 }
  it { should have_accessor(:guid)               }
  it { should have_accessor(:collector_id)       }
  it { should have_accessor(:collector_guid)     }
  it { should have_accessor(:questionnaire_name) }
  it { should have_accessor(:owner)              }
  it { should have_accessor(:executive)          }
  it { should have_accessor(:approver)           }
  it { should have_accessor(:datasource_id)      }
  it { should have_accessor(:modified)           }
  it { should have_accessor(:document)           }

  %w(owner executive approver).each do |method|
    describe "##{method}=" do
      it 'converts passed hash to GroupDocs::User object' do
        subject.send(:"#{method}=", { :first_name => 'Test' })
        user = subject.send(:"#{method}")
        user.should be_a(GroupDocs::User)
        user.first_name.should == 'Test'
      end

      it 'does nothing if GroupDocs::User is passed' do
        subject.send(:"#{method}=", GroupDocs::User.new(:first_name => 'Test'))
        subject.send(:"#{method}").first_name.should == 'Test'
      end
    end
  end

  describe '#modified' do
    it 'returns converted to Time object Unix timestamp' do
      subject.modified = 1330450135000
      subject.modified.should == Time.at(1330450135)
    end
  end

  describe "#document=" do
    it 'converts passed hash to GroupDocs::Storage::File object' do
      subject.document = { :id => 123 }
      subject.document.should be_a(GroupDocs::Storage::File)
    end

    it 'gets file from passed GroupDocs::Document' do
      document = GroupDocs::Document.new(:file => GroupDocs::Storage::File.new)
      subject.document = document
      subject.document.should == document.file
    end

    it 'does nothing if nil is passed' do
      subject.document = nil
      subject.document.should be_nil
    end
  end

  describe '#set_status!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_execution_status_set'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.set_status!(:submitted, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'parses status' do
      subject.should_receive(:parse_status).with(:submitted).and_return('Submitted')
      subject.set_status!(:submitted)
    end

    it 'updates status of execution object' do
      subject.set_status!(:submitted)
      subject.status.should == :submitted
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_execution_update'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash).and_return({})
      subject.update!
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#fill!' do
    before(:each) do
      mock_api_server(load_json('document_datasource'))
    end

    let(:datasource) do
      GroupDocs::DataSource.new(:id => 1)
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.fill!(datasource, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.fill!(datasource, :new_type => :pdf)
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if datasource is not GroupDocs::Datasource object' do
      lambda { subject.fill!('Datasource') }.should raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Job object' do
      subject.fill!(datasource).should be_a(GroupDocs::Job)
    end
  end
end
