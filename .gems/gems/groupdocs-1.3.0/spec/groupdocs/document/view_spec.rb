require 'spec_helper'

describe GroupDocs::Document::View do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:document)  }
  it { should have_accessor(:short_url) }
  it { should have_accessor(:viewed_on) }

  describe '#document=' do
    it 'sets document if GroupDocs::Document object is passed' do
      document = GroupDocs::Document.new(:file => GroupDocs::Storage::File.new)
      subject.document = document
      subject.document.should == document
    end

    it 'creates new GroupDocs::Document object from passed hash' do
      subject.document = { :id => 1, :name => 'test.pdf' }
      document = subject.document
      document.should be_a(GroupDocs::Document)
      document.file.id.should == 1
      document.file.name.should == 'test.pdf'
    end
  end

  describe '#viewed_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.viewed_on = 1330450135000
      subject.viewed_on.should == Time.at(1330450135)
    end
  end
end
