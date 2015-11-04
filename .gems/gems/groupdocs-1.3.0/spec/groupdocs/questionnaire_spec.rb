require 'spec_helper'

describe GroupDocs::Questionnaire do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('questionnaires_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.all!(:status => :draft)
      end.should_not raise_error(ArgumentError)
    end

    it 'parses status if passed' do
      status = :draft
      subject = described_class.new
      described_class.should_receive(:new).any_number_of_times.and_return(subject)
      subject.should_receive(:parse_status).with(status)
      described_class.all!(:status => status)
    end

    it 'returns an array of GroupDocs::Questionnaire objects' do
      questionnaires = described_class.all!
      questionnaires.should be_an(Array)
      questionnaires.each do |questionnaire|
        questionnaire.should be_a(GroupDocs::Questionnaire)
      end
    end
  end

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(1, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Questionnaire object' do
      described_class.get!(1).should be_a(GroupDocs::Questionnaire)
    end

    it 'returns nil if ResourceNotFound was raised' do
      GroupDocs::Api::Request.any_instance.should_receive(:execute!).and_raise(RestClient::ResourceNotFound)
      described_class.get!(1).should be_nil
    end
  end

  it { should have_accessor(:id)                  }
  it { should have_accessor(:guid)                }
  it { should have_accessor(:name)                }
  it { should have_accessor(:descr)               }
  it { should have_accessor(:pages)               }
  it { should have_accessor(:resolved_executions) }
  it { should have_accessor(:assigned_questions)  }
  it { should have_accessor(:total_questions)     }
  it { should have_accessor(:modified)            }
  it { should have_accessor(:expires)             }
  it { should have_accessor(:document_ids)        }

  it { should alias_accessor(:description, :descr) }

  describe '#pages=' do
    it 'converts each page to GroupDocs::Questionnaire::Page object if hash is passed' do
      subject.pages = [{ :number => 1, :title => 'Page1' }, { :number => 2, :title => 'Page2' }]
      pages = subject.pages
      pages.should be_an(Array)
      pages.each do |page|
        page.should be_a(GroupDocs::Questionnaire::Page)
      end
    end

    it 'saves each page if it is GroupDocs::Questionnaire::Page object' do
      page1 = GroupDocs::Questionnaire::Page.new(:number => 1)
      page2 = GroupDocs::Questionnaire::Page.new(:number => 2)
      subject.pages = [page1, page2]
      subject.pages.should include(page1)
      subject.pages.should include(page2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.pages = nil
      end.should_not change(subject, :pages)
    end
  end

  describe '#add_page' do
    it 'raises error if page is not GroupDocs::Questionnaire::Page object' do
      lambda { subject.add_page('Page') }.should raise_error(ArgumentError)
    end

    it 'adds page to pages instance variable' do
      page = GroupDocs::Questionnaire::Page.new
      lambda do
        subject.add_page(page)
      end.should change(subject, :pages).to([page])
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.create!
    end

    it 'updates questionnaire attributes' do
      lambda do
        subject.create!
      end.should change {
        subject.id
        subject.guid
        subject.name
      }
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_update'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.update!
    end
  end

  describe '#remove!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_remove'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#datasources!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_datasources'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.datasources!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::DataSource objects' do
      datasources = subject.datasources!
      datasources.should be_an(Array)
      datasources.each do |datasource|
        datasource.should be_a(GroupDocs::DataSource)
      end
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

  describe '#collectors!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_collectors'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.collectors!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Questionnaire::Collector objects' do
      collectors = subject.collectors!
      collectors.should be_an(Array)
      collectors.each do |collector|
        collector.should be_a(GroupDocs::Questionnaire::Collector)
      end
    end
  end

  describe '#metadata!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.metadata!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Questionnaire object' do
      subject.metadata!.should be_a(GroupDocs::Questionnaire)
    end
  end

  describe '#update_metadata!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": { "questionnaire_id": 123456 }}')
    end

    let!(:metadata) { GroupDocs::Questionnaire.new }

    it 'accepts access credentials hash' do
      lambda do
        subject.update_metadata!(metadata, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if metadata is not GroupDocs::Questionnaire object' do
      lambda { subject.update_metadata!('Metadata') }.should raise_error(ArgumentError)
    end

    it 'uses hashed version as payload' do
      metadata.should_receive(:to_hash)
      subject.update_metadata!(metadata)
    end
  end

  describe '#fields!' do
    before(:each) do
      mock_api_server(load_json('document_fields'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.fields!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Document::Field objects' do
      fields = subject.fields!
      fields.should be_an(Array)
      fields.each do |field|
        field.should be_a(GroupDocs::Document::Field)
      end
    end
  end
end
