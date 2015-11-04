require 'spec_helper'

describe GroupDocs::Storage::Folder do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::AccessMode

  describe '.create!' do
    before(:each) do
      mock_api_server(load_json('folder_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.create!('Test', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Storage::Folder object' do
      folder = described_class.create!('Test')
      folder.should be_a(GroupDocs::Storage::Folder)
    end
  end

  describe '.list!' do
    before(:each) do
      mock_api_server(load_json('folder_list'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.list!('', {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing path' do
      lambda { described_class.list!('test') }.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      lambda { described_class.list!('', :page => 1, :count => 1) }.should_not raise_error(ArgumentError)
    end

    it 'creates new instance of GroupDocs::Storage::Folder and calls #list!' do
      folder = stub('folder')
      GroupDocs::Storage::Folder.should_receive(:new).with(:path => '').and_return(folder)
      folder.should_receive(:list!).with({}, {})
      described_class.list!
    end
  end

  it { should have_accessor(:id)           }
  it { should have_accessor(:size)         }
  it { should have_accessor(:folder_count) }
  it { should have_accessor(:file_count)   }
  it { should have_accessor(:created_on)   }
  it { should have_accessor(:modified_on)  }
  it { should have_accessor(:url)          }
  it { should have_accessor(:name)         }
  it { should have_accessor(:version)      }
  it { should have_accessor(:type)         }

  describe '#created_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.created_on = 1330450135000
      subject.created_on.should == Time.at(1330450135)
    end
  end

  describe '#modified_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.modified_on = 1330450135000
      subject.modified_on.should == Time.at(1330450135)
    end
  end

  describe '#list!' do
    before(:each) do
      mock_api_server(load_json('folder_list'))
      subject.stub(:path => '/Test1')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.list!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      lambda { subject.list!(:page => 1, :count => 1) }.should_not raise_error(ArgumentError)
    end

    it 'capitalizes :order_by option' do
      options = { :order_by => 'field' }
      lambda { subject.list!(options) }.should change { options[:order_by] }.to('Field')
    end

    it 'camelizes :order_by option' do
      options = { :order_by => 'modified_on' }
      lambda { subject.list!(options) }.should change { options[:order_by] }.to('ModifiedOn')
    end

    it 'returns array' do
      subject.list!.should be_an(Array)
    end

    it 'returns empty array if nothing is listed in directory' do
      mock_api_server('{"result": {"folders": [], "files": []}, "status": "Ok"}')
      subject.list!.should be_empty
    end

    it 'determines folders in response' do
      subject.list!.detect do |entity|
        entity.id == 1
      end.should be_a(GroupDocs::Storage::Folder)
    end

    it 'determines files in response' do
      subject.list!.detect do |entity|
        entity.id == 2
      end.should be_a(GroupDocs::Storage::File)
    end
  end

  describe '#move!' do
    before(:each) do
      subject.path = ''
      mock_api_server(load_json('folder_move'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.move!('Test', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns moved to folder path' do
      moved = subject.move!('Test2/Test1')
      moved.should be_a(String)
      moved.should == 'Test2/Test1/'
    end
  end

  describe '#copy!' do
    before(:each) do
      subject.path = ''
      mock_api_server(load_json('folder_move'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.copy!('/Test2', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns moved to folder path' do
      moved = subject.copy!('Test2/Test1')
      moved.should be_a(String)
      moved.should == 'Test2/Test1/'
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('folder_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'calls create! class method and pass parameters to it' do
      subject = described_class.new(:name => 'Test1')
      described_class.should_receive(:create!).with('Test1', {})
      subject.create!
    end

    it 'returns new GroupDocs::Storage::Folder object' do
      subject = described_class.new(:name => 'Test1')
      new_folder = subject.create!
      new_folder.should be_a(GroupDocs::Storage::Folder)
      new_folder.should_not == subject
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server(load_json('folder_delete'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'determines path by name' do
      subject.should_receive(:name).and_return('Test1')
      subject.delete!
    end
  end

  describe '#sharers!' do
    before(:each) do
      mock_api_server(load_json('folder_sharers_get'))
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
      mock_api_server(load_json('folder_sharers_set'))
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
      mock_api_server(load_json('folder_sharers_remove'))
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
end
