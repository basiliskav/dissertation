require 'spec_helper'

describe GroupDocs::Job do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('jobs_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.all!(:page => 1, :count => 2)
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Job objects' do
      jobs = described_class.all!
      jobs.should be_an(Array)
      jobs.each do |job|
        job.should be_a(GroupDocs::Job)
      end
    end
  end

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('job_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(1, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Job object' do
      described_class.get!(1).should be_a(GroupDocs::Job)
    end
  end

  describe '.create!' do
    before(:each) do
      mock_api_server(load_json('job_create'))
    end

    let(:actions) { %w(convert compress_zip) }

    it 'accepts access credentials hash' do
      lambda do
        described_class.create!({ :actions => %w(convert) }, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if actions are passed' do
      lambda { described_class.create!({}) }.should raise_error(ArgumentError)
    end

    it 'convert actions to byte flag' do
      described_class.should_receive(:convert_actions_to_byte).with(actions).and_return(5)
      described_class.create!(:actions => actions)
    end

    it 'converts array of out formats to string' do
      formats = %w(pdf txt)
      formats.should_receive(:join).with(?;)
      described_class.create!(:actions => actions, :out_formats => formats)
    end

    it 'returns GroupDocs::Job object' do
      described_class.create!(:actions => actions).should be_a(GroupDocs::Job)
    end
  end

  it { should have_accessor(:id)             }
  it { should have_accessor(:guid)           }
  it { should have_accessor(:name)           }
  it { should have_accessor(:priority)       }
  it { should have_accessor(:actions)        }
  it { should have_accessor(:email_results)  }
  it { should have_accessor(:url_only)       }
  it { should have_accessor(:documents)      }
  it { should have_accessor(:requested_time) }

  describe '#documents=' do
    let(:response) do
      {
        :inputs => [
          { :id => 1, :guid => 'fhy9yh94u238dgf', :status => 0, :outputs => [] },
          { :id => 2, :guid => 'ofh9rhy9rfohf9s', :status => 2, :outputs => [] }
        ]
      }
    end

    it 'saves documents as array of GroupDocs::Document objects' do
      subject.documents = response
      documents = subject.documents
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.documents = nil
      end.should_not change(subject, :documents)
    end
  end

  describe '#requested_time' do
    it 'converts timestamp to Time object' do
      subject.requested_time = 1330450135000
      subject.requested_time.should == Time.at(1330450135)
    end
  end

  describe '#actions' do
    it 'converts actions to human-readable format' do
      subject.actions = 'Convert, Combine, CompressZip'
      subject.actions.should == [:convert, :combine, :compress_zip]
    end

    it 'does nothing if there are no actions' do
      subject.actions = nil
      subject.actions.should be_nil
    end
  end

  describe '#documents!' do
    before(:each) do
      mock_api_server(load_json('job_documents'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.documents!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'updates job status' do
      subject.documents!
      subject.status.should == :archived
    end

    it 'returns hash' do
      subject.documents!.should be_a(Hash)
    end

    it 'returns array of input documents' do
      documents = subject.documents![:inputs]
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end

    it 'returns array of output documents' do
      documents = subject.documents![:outputs]
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end

    it 'returns empty arrays if there are no documents' do
      mock_api_server('{ "status": "Ok", "result": {}}')
      subject.documents!.should == { :inputs => [], :outputs => [] }
    end
  end

  describe '#add_document!' do
    before(:each) do
      mock_api_server(load_json('job_file_add'))
    end

    let(:document) do
      GroupDocs::Document.new(:file => GroupDocs::Storage::File.new)
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_document!(document, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.add_document!(document, :output_formats => %w(pdf txt))
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if document is not an instance of GroupDocs::Document' do
      lambda { subject.add_document!('Document') }.should raise_error(ArgumentError)
    end

    it 'returns document ID' do
      subject.add_document!(document).should be_an(Integer)
    end
  end

  describe '#delete_document!' do
    before(:each) do
      mock_api_server('{ "result": {}, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete_document!('a9ufg8s7dfgsdf', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns empty hash' do
      subject.delete_document!('a9ufg8s7dfgsdf').should be_empty
    end
  end

  describe '#add_datasource!' do
    let(:document) do
      GroupDocs::Document.new(:file => GroupDocs::Storage::File.new)
    end

    let(:datasource) do
      GroupDocs::DataSource.new
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_datasource!(document, datasource, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if document is not an instance of GroupDocs::Document' do
      lambda { subject.add_datasource!('Document') }.should raise_error(ArgumentError)
    end

    it 'raises error if datasource is not an instance of GroupDocs::DataSource' do
      lambda { subject.add_datasource!(document, 'DataSource') }.should raise_error(ArgumentError)
    end
  end

  describe '#add_url!' do
    before(:each) do
      mock_api_server(load_json('job_add_url'))
    end

    let(:url) { 'http://www.google.com' }

    it 'accepts access credentials hash' do
      lambda do
        subject.add_url!(url, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.add_url!(url, :out_formats => %W(pdf txt))
      end.should_not raise_error(ArgumentError)
    end

    it 'returns document ID' do
      subject.add_url!(url).should be_an(Integer)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('job_update'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'parses status' do
      subject.should_receive(:parse_status).with(:draft).and_return(-1)
      subject.update!(:status => :draft)
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {} }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#convert_actions_to_byte' do
    let(:actions) { %w(convert compare) }

    it 'raises error if actions is not an array' do
      lambda { described_class.convert_actions_to_byte(:export) }.should raise_error(ArgumentError)
    end

    it 'raises error if action is unknown' do
      lambda { described_class.convert_actions_to_byte(%w(unknown)) }.should raise_error(ArgumentError)
    end

    it 'converts each action to Symbol' do
      actions.each do |action|
        symbol = action.to_sym
        action.should_receive(:to_sym).and_return(symbol)
      end
      described_class.convert_actions_to_byte(actions)
    end

    it 'returns correct byte flag' do
      described_class.convert_actions_to_byte(actions).should == 257
    end
  end
end
