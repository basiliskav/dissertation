require 'spec_helper'

describe GroupDocs::Questionnaire::Collector do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  subject do
    questionnaire = GroupDocs::Questionnaire.new
    described_class.new(:questionnaire => questionnaire)
  end

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_collector'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!('9fh349hfdskf', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Questionnaire::Collector object' do
      described_class.get!('9fh349hfdskf').should be_a(GroupDocs::Questionnaire::Collector)
    end
  end

  it { should have_accessor(:id)                  }
  it { should have_accessor(:guid)                }
  it { should have_accessor(:questionnaire)       }
  it { should have_accessor(:questionnaire_id)    }
  it { should have_accessor(:type)                }
  it { should have_accessor(:resolved_executions) }
  it { should have_accessor(:emails)              }
  it { should have_accessor(:modified)            }

  describe '#initialize' do
    it 'raises error if questionnaire is not specified' do
      lambda { described_class.new }.should raise_error(ArgumentError)
    end

    it 'raises error if questionnaire is not an instance of GroupDocs::Questionnaire' do
      lambda { described_class.new(:questionnaire => '') }.should raise_error(ArgumentError)
    end
  end

  describe '#type=' do
    it 'saves type in machine readable format if symbol is passed' do
      subject.type = :binary
      subject.instance_variable_get(:@type).should == 'Binary'
    end

    it 'does nothing if parameter is not symbol' do
      subject.type = 'Binary'
      subject.instance_variable_get(:@type).should == 'Binary'
    end
  end

  describe '#type' do
    it 'returns converted to human-readable format type' do
      subject.should_receive(:parse_status).with('Embedded').and_return(:embedded)
      subject.type = 'Embedded'
      subject.type.should == :embedded
    end
  end

  describe '#modified' do
    it 'returns converted to Time object Unix timestamp' do
      subject.modified = 1330450135000
      subject.modified.should == Time.at(1330450135)
    end
  end

  describe '#add!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_collectors_add'))
      subject.questionnaire = GroupDocs::Questionnaire.new
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'updates id and guid with response' do
      lambda do
        subject.add!
      end.should change {
        subject.id
        subject.guid
      }
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": { "collector_id": 123456 }}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#remove!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#executions!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_executions'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.executions!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Questionnaire::Execution objects' do
      executions = subject.executions!
      executions.should be_an(Array)
      executions.each do |execution|
        execution.should be_a(GroupDocs::Questionnaire::Execution)
      end
    end
  end

  describe '#add_execution!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_execution_add'))
    end

    let(:execution) { GroupDocs::Questionnaire::Execution.new }

    it 'accepts access credentials hash' do
      lambda do
        subject.add_execution!(execution, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if execution is not GroupDocs::Questionnaire::Execution object' do
      lambda { subject.add_execution!('Execution') }.should raise_error(ArgumentError)
    end

    it 'uses hashed version of execution along with executive payload' do
      execution.should_receive(:to_hash)
      subject.add_execution!(execution)
    end

    it 'returns GroupDocs::Questionnaire::Execution object' do
      subject.add_execution!(execution).should be_a(GroupDocs::Questionnaire::Execution)
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
