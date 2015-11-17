require 'spec_helper'

describe GroupDocs::Document do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  subject do
    file = GroupDocs::Storage::File.new
    described_class.new(:file => file)
  end

  describe '.views!' do
    before(:each) do
      mock_api_server(load_json('document_views'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.views!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Document::View objects' do
      views = described_class.views!
      views.should be_an(Array)
      views.each do |view|
        view.should be_a(GroupDocs::Document::View)
      end
    end
  end

  describe '.templates!' do
    before(:each) do
      mock_api_server(load_json('templates_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.templates!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Document objects' do
      templates = described_class.templates!
      templates.should be_an(Array)
      templates.each do |template|
        template.should be_a(GroupDocs::Document)
      end
    end
  end

  describe '.sign_documents!' do
    before(:each) do
      mock_api_server(load_json('sign_documents'))
    end

    let(:documents) do
      [GroupDocs::Document.new(:file => GroupDocs::Storage::File.new(:name => 'Document1', :local_path => __FILE__)),
       GroupDocs::Document.new(:file => GroupDocs::Storage::File.new(:name => 'Document2', :local_path => 'spec/support/files/resume.pdf'))]
    end
    let(:signatures) { [GroupDocs::Signature.new(:name => 'John Smith', :image_path => 'spec/support/files/signature.png', :position => {})] }

    it 'accepts access credentials hash' do
      lambda do
        described_class.sign_documents!(documents, signatures, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if document is not GroupDocs::Document object' do
      lambda { described_class.sign_documents!(['Document'], signatures) }.should raise_error(ArgumentError)
    end

    it 'raises error if document file does not have name' do
      documents = [GroupDocs::Document.new(:file => GroupDocs::Storage::File.new(:local_path => __FILE__))]
      lambda { described_class.sign_documents!(documents, signatures) }.should raise_error(ArgumentError)
    end

    it 'raises error if document file does not have local path' do
      documents = [GroupDocs::Document.new(:file => GroupDocs::Storage::File.new(:name => 'Document'))]
      lambda { described_class.sign_documents!(documents, signatures) }.should raise_error(ArgumentError)
    end

    it 'raises error if signature is not GroupDocs::Signature object' do
      lambda { described_class.sign_documents!(documents, ['Signature']) }.should raise_error(ArgumentError)
    end

    it 'raises error if signature does not have name' do
      signatures = [GroupDocs::Signature.new(:image_path => __FILE__, :position => {})]
      lambda { described_class.sign_documents!(documents, signatures) }.should raise_error(ArgumentError)
    end

    it 'raises error if signature does not have image path' do
      signatures = [GroupDocs::Signature.new(:name => 'John Smith', :position => {})]
      lambda { described_class.sign_documents!(documents, signatures) }.should raise_error(ArgumentError)
    end

    it 'raises error if signature does not have position' do
      signatures = [GroupDocs::Signature.new(:name => 'John Smith', :image_path => __FILE__)]
      lambda { described_class.sign_documents!(documents, signatures) }.should raise_error(ArgumentError)
    end

    it 'detects each document and signature file MIME type' do
      documents.each  { |document| described_class.should_receive(:mime_type).with(document.file.local_path).once }
      signatures.each { |signature| described_class.should_receive(:mime_type).with(signature.image_path).once }
      described_class.sign_documents!(documents, signatures)
    end

    it 'returns array of GroupDocs::Document.objects' do
      signed_documents = described_class.sign_documents!(documents, signatures)
      signed_documents.should be_an(Array)
      signed_documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end

    it 'calculates file name for each signed document' do
      signed_documents = described_class.sign_documents!(documents, signatures)
      signed_documents[0].file.name.should == "#{documents[0].file.name}_signed.pdf"
      signed_documents[1].file.name.should == "#{documents[1].file.name}_signed.pdf"
    end
  end

  describe ',metadata!' do
    before(:each) do
      mock_api_server(load_json('document_metadata'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.metadata!('document_one.doc', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Document::MetaData object' do
      described_class.metadata!('document_one.doc').should be_a(GroupDocs::Document::MetaData)
    end

    it 'sets last view as GroupDocs::Document::View object if document was viewed at least once' do
      described_class.metadata!('document_one.doc').last_view.should be_a(GroupDocs::Document::View)
    end

    it 'does not set last view if document has never been viewed' do
      mock_api_server('{ "status": "Ok", "result": { "last_view": null }}')
      described_class.metadata!('document_one.doc').last_view.should be_nil
    end
  end

  it { should have_accessor(:file)           }
  it { should have_accessor(:process_date)   }
  it { should have_accessor(:outputs)        }
  it { should have_accessor(:output_formats) }
  it { should have_accessor(:order)          }
  it { should have_accessor(:field_count)    }

  it { should have_alias(:access_mode=, :access_mode_set!) }

  describe '#outputs=' do
    let(:response) do
      [
        { :ftype => 1, :guid => 'fhy9yh94u238dgf' },
        { :ftype => 2, :guid => 'ofh9rhy9rfohf9s' }
      ]
    end

    it 'saves outputs as array of GroupDocs::Storage::File objects' do
      subject.outputs = response
      outputs = subject.outputs
      outputs.should be_an(Array)
      outputs.each do |output|
        output.should be_a(GroupDocs::Storage::File)
      end
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.outputs = nil
      end.should_not change(subject, :outputs)
    end
  end

  describe '#output_formats' do
    it 'returns parsed array of output formats' do
      subject.output_formats = "pdf,tiff,doc"
      subject.output_formats.should == [:pdf, :tiff, :doc]
    end
  end

  describe '#process_date' do
    it 'returns converted to Time object Unix timestamp' do
      subject.process_date = 1330450135000
      subject.process_date.should == Time.at(1330450135)
    end
  end

  describe '#initialize' do
    it 'raises error if file is not specified' do
      lambda { described_class.new }.should raise_error(ArgumentError)
    end

    it 'raises error if file is not an instance of GroupDocs::Storage::File' do
      lambda { described_class.new(:file => '') }.should raise_error(ArgumentError)
    end
  end

 describe '#page_images!' do
    before(:each) do
      mock_api_server(load_json('document_page_images_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.page_images!(640, 480, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.page_images!(640, 480, :first_page => 0, :page_count => 1)
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of URLs' do
      urls = subject.page_images!(640, 480)
      urls.should be_an(Array)
      urls.each do |url|
        url.should be_a(String)
      end
    end
  end

  describe '#thumbnails!' do
    before(:each) do
      mock_api_server(load_json('document_thumbnails'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.thumbnails!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.thumbnails!(:page_number => 0, :page_count => 1)
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of URLs' do
      urls = subject.thumbnails!
      urls.should be_an(Array)
      urls.each do |url|
        url.should be_a(String)
      end
    end
  end

  describe '#access_mode!' do
    before(:each) do
      mock_api_server(load_json('document_access_info_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.access_mode!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns access mode in human readable presentation' do
      subject.should_receive(:parse_access_mode).with('Private').and_return(:private)
      subject.access_mode!.should == :private
    end
  end

  describe '#access_mode_set!' do
    before(:each) do
      mock_api_server('{"status": "Ok", "result": {"access": "Private" }}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.access_mode_set!(:private, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'sets corresponding access mode' do
      described_class::ACCESS_MODES.should_receive(:[]).with(:private).and_return(0)
      subject.should_receive(:parse_access_mode).with('Private').and_return(:private)
      subject.access_mode_set!(:private)
    end

    it 'returns set of access modes' do
      subject.access_mode_set!(:private).should == :private
    end

    it 'is aliased to #access_mode=' do
      subject.should have_alias(:access_mode=, :access_mode_set!)
    end
  end

  describe '#formats!' do
    before(:each) do
      mock_api_server(load_json('document_formats'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.formats!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of symbols' do
      formats = subject.formats!
      formats.should be_an(Array)
      formats.each do |format|
        format.should be_a(Symbol)
      end
    end
  end

  describe '#metadata!' do
    before(:each) do
      mock_api_server(load_json('document_metadata'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.metadata!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Document::MetaData object' do
      subject.metadata!.should be_a(GroupDocs::Document::MetaData)
    end

    it 'sets last view as GroupDocs::Document::View object if document was viewed at least once' do
      subject.metadata!.last_view.should be_a(GroupDocs::Document::View)
    end

    it 'uses self document in last view object' do
      subject.metadata!.last_view.document.should == subject
    end

    it 'does not set last view if document has never been viewed' do
      mock_api_server('{ "status": "Ok", "result": { "last_view": null }}')
      subject.metadata!.last_view.should be_nil
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

  describe '#sharers!' do
    before(:each) do
      mock_api_server(load_json('document_access_info_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.sharers!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::User objects' do
      users = subject.sharers!
      users.should be_an(Array)
      users.each do |user|
        user.should be_a(GroupDocs::User)
      end
    end
  end

  describe '#sharers_set!' do
    before(:each) do
      mock_api_server(load_json('document_sharers_set'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.sharers_set!(%w(test1@email.com), :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::User objects' do
      users = subject.sharers_set!(%w(test1@email.com))
      users.should be_an(Array)
      users.each do |user|
        user.should be_a(GroupDocs::User)
      end
    end

    it 'clears sharers if empty array is passed' do
      subject.should_receive(:sharers_clear!)
      subject.sharers_set!([])
    end

    it 'clears sharers if nil is passed' do
      subject.should_receive(:sharers_clear!)
      subject.sharers_set!(nil)
    end
  end

  describe '#sharers_clear!' do
    before(:each) do
      mock_api_server(load_json('document_sharers_remove'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.sharers_clear!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'clears sharers list and returns nil' do
      subject.sharers_clear!.should be_nil
    end
  end

  describe '#convert!' do
    before(:each) do
      mock_api_server(load_json('document_convert'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.convert!(:pdf, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.convert!(:pdf, :email_results => true)
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Job object' do
      subject.convert!(:pdf).should be_a(GroupDocs::Job)
    end
  end

  describe '#questionnaires!' do
    before(:each) do
      mock_api_server(load_json('document_questionnaires'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.questionnaires!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Questionnaire objects' do
      questionnaires = subject.questionnaires!
      questionnaires.should be_an(Array)
      questionnaires.each do |questionnaire|
        questionnaire.should be_a(GroupDocs::Questionnaire)
      end
    end
  end

  describe '#add_questionnaire!' do
    let(:questionnaire) do
      GroupDocs::Questionnaire.new(:id => 1)
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_questionnaire!(questionnaire, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if questionnaire is not GroupDocs::Questionnaire object' do
      lambda { subject.add_questionnaire!('Questionnaire') }.should raise_error(ArgumentError)
    end
  end

  describe '#create_questionnaire!' do
    before(:each) do
      mock_api_server(load_json('document_questionnaire_create'))
    end

    let(:questionnaire) do
      GroupDocs::Questionnaire.new(:name => 'Q1')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create_questionnaire!(questionnaire, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if questionnaire is not GroupDocs::Questionnaire object' do
      lambda { subject.create_questionnaire!('Questionnaire') }.should raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Questionnaire object' do
      subject.create_questionnaire!(questionnaire).should be_a(GroupDocs::Questionnaire)
    end

    it 'uses hashed version of questionnaire as request body' do
      questionnaire.should_receive(:to_hash)
      subject.create_questionnaire!(questionnaire)
    end

    it 'updates ID from response to questionnaire' do
      lambda do
        subject.create_questionnaire!(questionnaire)
      end.should change(questionnaire, :id)
    end
  end

  describe '#remove_questionnaire!' do
    let(:questionnaire) do
      GroupDocs::Questionnaire.new(:id => 1)
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove_questionnaire!(questionnaire, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if questionnaire is not GroupDocs::Questionnaire object' do
      lambda { subject.remove_questionnaire!('Questionnaire') }.should raise_error(ArgumentError)
    end
  end

  describe '#datasource!' do
    before(:each) do
      mock_api_server(load_json('document_datasource'))
    end

    let(:datasource) do
      GroupDocs::DataSource.new(:id => 1)
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.datasource!(datasource, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.datasource!(datasource, :new_type => :pdf)
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if datasource is not GroupDocs::Datasource object' do
      lambda { subject.datasource!('Datasource') }.should raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Job object' do
      job = subject.datasource!(datasource)
      job.should be_a(GroupDocs::Job)
    end
  end

  describe '#annotations!' do
    before(:each) do
      mock_api_server(load_json('annotation_list'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.annotations!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Document::Annotation objects' do
      annotations = subject.annotations!
      annotations.should be_an(Array)
      annotations.each do |annotation|
        annotation.should be_a(GroupDocs::Document::Annotation)
      end
    end

    it 'returns empty array if annotations are null in response' do
      mock_api_server('{ "status": "Ok", "result": { "annotations": null }}')
      subject.annotations!.should be_empty
    end
  end

  describe '#details!' do
    before(:each) do
      mock_api_server(load_json('comparison_document'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.details!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns hash of document details' do
      subject.details!.should be_a(Hash)
    end
  end

  describe '#compare!' do
    before(:each) do
      mock_api_server(load_json('comparison_compare'))
    end

    let(:document) do
      GroupDocs::Document.new(:file => GroupDocs::Storage::File.new)
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.compare!(document, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if document is not GroupDocs::Document object' do
      lambda { subject.compare!('Document') }.should raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Job object' do
      subject.compare!(document).should be_a(GroupDocs::Job)
    end
  end

  describe '#changes!' do
    before(:each) do
      mock_api_server(load_json('comparison_changes'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.changes!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Document::Change objects' do
      changes = subject.changes!
      changes.should be_an(Array)
      changes.each do |change|
        change.should be_a(GroupDocs::Document::Change)
      end
    end
  end


  describe '#collaborators!' do
    before(:each) do
      mock_api_server(load_json('annotation_collaborators_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.collaborators!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::User objects' do
      users = subject.collaborators!
      users.should be_an(Array)
      users.each do |user|
        user.should be_a(GroupDocs::User)
      end
    end
  end

  describe '#set_collaborators!' do
    before(:each) do
      mock_api_server(load_json('annotation_collaborators_set'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.set_collaborators!(%w(test1@email.com), 1, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts version' do
      lambda do
        subject.set_collaborators!(%w(test1@email.com), 1)
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::User objects' do
      users = subject.set_collaborators!(%w(test1@email.com))
      users.should be_an(Array)
      users.each do |user|
        user.should be_a(GroupDocs::User)
      end
    end
  end

  describe '#add_collaborator!' do
    before(:each) do
      mock_api_server(load_json('annotation_collaborators_get'))
    end

    let!(:collaborator) { GroupDocs::User.new }

    it 'accepts access credentials hash' do
      lambda do
        subject.add_collaborator!(collaborator, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of collaborator as request body' do
      collaborator.should_receive(:to_hash)
      subject.add_collaborator! collaborator
    end

    it 'raises error if collaborator is not an instance of GroupDocs::User' do
      lambda { subject.add_collaborator!('collaborator') }.should raise_error(ArgumentError)
    end
  end

  describe '#set_reviewers!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    let!(:reviewers) { [GroupDocs::User.new, GroupDocs::User.new] }

    it 'accepts access credentials hash' do
      lambda do
        subject.set_reviewers!(reviewers, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of each reviewer as request body' do
      reviewers.each do |reviewer|
        reviewer.should_receive(:to_hash)
      end
      subject.set_reviewers! reviewers
    end
  end

  describe '#shared_link_access_rights!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": { "accessRights": 15 }}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.shared_link_access_rights!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'converts response byte flag into array of access rights' do
      subject.should_receive(:convert_byte_to_access_rights).with(15)
      subject.shared_link_access_rights!
    end

    it 'returns array of access rights symbols' do
      access_rights = subject.shared_link_access_rights!
      access_rights.should be_an(Array)
      access_rights.each do |access_right|
        access_right.should be_a(Symbol)
      end
    end

    it 'returns empty array if access rights is null' do
      mock_api_server('{ "status": "Ok", "result": { "accessRights": null }}')
      subject.shared_link_access_rights!.should be_empty
    end
  end

  describe '#set_shared_link_access_rights!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.set_shared_link_access_rights!(%w(view), :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'converts array of access rights into byte flag' do
      subject.should_receive(:convert_access_rights_to_byte).with(%w(view))
      subject.set_shared_link_access_rights! %w(view)
    end
  end

  describe '#set_session_callback!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.set_session_callback!('http://www.example.com', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#method_missing' do
    it 'passes unknown methods to file object' do
      lambda { subject.name }.should_not raise_error(NoMethodError)
    end

    it 'raises NoMethodError if neither self nor file responds to method' do
      lambda { subject.unknown_method }.should raise_error(NoMethodError)
    end
  end

  describe '#respond_to?' do
    it 'returns true if self responds to method' do
      subject.respond_to?(:metadata!).should be_true
    end

    it 'returns true if file object responds to method' do
      subject.respond_to?(:name).should be_true
    end

    it 'returns false if neither self nor file responds to method' do
      subject.respond_to?(:unknown).should be_false
    end
  end
end
