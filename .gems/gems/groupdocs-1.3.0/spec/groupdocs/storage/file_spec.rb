require 'spec_helper'

describe GroupDocs::Storage::File do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::AccessMode

  describe '.upload!' do
    before(:each) do
      mock_api_server(load_json('file_upload'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.upload!(__FILE__, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.upload!(__FILE__, :path => 'folder1')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses root folder by default' do
      opts = {}
      described_class.upload!(__FILE__, opts)
      opts[:path].should == ''
    end

    it 'uses file name by default' do
      opts = {}
      described_class.upload!(__FILE__, opts)
      opts[:name].should == Object::File.basename(__FILE__)
    end

    it 'uses name if passed' do
      opts = { :name => 'file.pdf' }
      described_class.upload!(__FILE__, opts)
      opts[:name].should == opts[:name]
    end

    it 'returns GroupDocs::Storage::File object' do
      described_class.upload!(__FILE__).should be_a(GroupDocs::Storage::File)
    end
  end

  describe '.upload_web!' do
    before(:each) do
      mock_api_server(load_json('file_upload'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.upload_web!('http://www.google.com', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Storage::File object' do
      described_class.upload_web!('http://www.google.com').should be_a(GroupDocs::Storage::File)
    end
  end

  it { should have_accessor(:id)          }
  it { should have_accessor(:guid)        }
  it { should have_accessor(:known)       }
  it { should have_accessor(:size)        }
  it { should have_accessor(:thumbnail)   }
  it { should have_accessor(:created_on)  }
  it { should have_accessor(:modified_on) }
  it { should have_accessor(:url)         }
  it { should have_accessor(:name)        }
  it { should have_accessor(:version)     }
  it { should have_accessor(:type)        }
  it { should have_accessor(:file_type)   }
  it { should have_accessor(:path)        }
  it { should have_accessor(:local_path)  }

  it { should have_alias(:adj_name=, :name=) }

  describe '#type=' do
    it 'saves type in machine readable format if symbol is passed' do
      subject.type = :words
      subject.instance_variable_get(:@type).should == 'Words'
    end

    it 'does nothing if parameter is not symbol' do
      subject.type = 'Words'
      subject.instance_variable_get(:@type).should == 'Words'
    end

    it 'raises error if type is unknown' do
      lambda { subject.type = :unknown }.should raise_error(ArgumentError)
    end
  end

  describe '#type' do
    it 'returns type in human-readable format' do
      subject.type = 'Words'
      subject.type.should == :words
    end
  end

  describe '#file_type' do
    it 'returns file type in human-readable format' do
      subject.file_type = 'Doc'
      subject.file_type.should == :doc
    end
  end

  describe '#created_on' do
    it 'converts timestamp to Time object' do
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

  describe '#download!' do
    before(:each) do
      mock_api_server(File.read('spec/support/files/resume.pdf'))
      subject.stub(:name => 'resume.pdf')
    end

    let(:path) { Dir.tmpdir }

    it 'accepts access credentials hash' do
      lambda do
        subject.download!(path, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'downloads file to given path' do
      file = stub('file')
      Object::File.should_receive(:open).with("#{path}/resume.pdf", 'wb').and_yield(file)
      file.should_receive(:write).with(File.read('spec/support/files/resume.pdf'))
      subject.download!(path)
    end

    it 'returns saved file path' do
      subject.download!(path).should == "#{path}/resume.pdf"
    end
  end

  describe '#move!' do
    before(:each) do
      mock_api_server(load_json('file_move'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.move!('folder1', {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options credentials hash' do
      lambda do
        subject.move!('folder1', :name => 'file.pdf')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses current file name by default' do
      subject.name = 'resume.pdf'
      opts = {}
      subject.move!('folder1', opts)
      opts[:name].should == subject.name
    end

    it 'uses name if passed' do
      opts = { :name => 'file.pdf' }
      subject.move!('folder1', opts)
      opts[:name].should == opts[:name]
    end

    it 'returns moved to file' do
      subject.move!('folder1').should be_a(GroupDocs::Storage::File)
    end
  end

  describe '#rename!' do
    before(:each) do
      subject.path = '/'
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.rename!('resume.pdf', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses #move! to rename file' do
      subject.should_receive(:move!).with(subject.path, { :name => 'resume2.pdf' }, {})
      subject.rename!('resume2.pdf')
    end
  end

  describe '#copy!' do
    before(:each) do
      mock_api_server(load_json('file_copy'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.copy!('resume.pdf', {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options credentials hash' do
      lambda do
        subject.copy!('folder1', :name => 'file.pdf')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses current file name by default' do
      subject.name = 'resume.pdf'
      opts = {}
      subject.copy!('folder1', opts)
      opts[:name].should == subject.name
    end

    it 'uses name if passed' do
      opts = { :name => 'file.pdf' }
      subject.copy!('folder1', opts)
      opts[:name].should == opts[:name]
    end

    it 'returns copied to file' do
      subject.copy!('/resume2.pdf').should be_a(GroupDocs::Storage::File)
    end
  end

  describe '#compress!' do
    before(:each) do
      mock_api_server(load_json('file_compress'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.compress!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns archived file' do
      subject.stub(:name => 'resume.pdf')
      subject.compress!.should be_a(GroupDocs::Storage::File)
    end

    it 'creates archive filename as filename + archive type' do
      subject.stub(:name => 'resume.pdf')
      subject.compress!.name.should == 'resume.pdf.zip'
    end
  end

  describe '#delete!' do
    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses file guid' do
      mock_api_server(load_json('file_delete'))
      subject.should_receive(:guid).and_return('guid')
      subject.delete!
    end
  end

  describe '#move_to_trash!' do
    it 'accepts access credentials hash' do
      lambda do
        subject.move_to_trash!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#to_document' do
    it 'creates new GroupDocs::Document' do
      subject.to_document.should be_a(GroupDocs::Document)
    end

    it 'passes self as file for GroupDocs::Document' do
      subject.to_document.file.should == subject
    end
  end
end
