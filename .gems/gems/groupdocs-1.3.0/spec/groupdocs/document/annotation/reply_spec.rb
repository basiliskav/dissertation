require 'spec_helper'

describe GroupDocs::Document::Annotation::Reply do

  it_behaves_like GroupDocs::Api::Entity

  subject do
    file = GroupDocs::Storage::File.new
    document = GroupDocs::Document.new(:file => file)
    annotation = GroupDocs::Document::Annotation.new(:document => document)
    described_class.new(:annotation => annotation)
  end

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('annotation_replies_get'))
    end

    let(:annotation) do
      document = GroupDocs::Document.new(:file => GroupDocs::Storage::File.new)
      GroupDocs::Document::Annotation.new(:document => document)
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(annotation, {}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.get!(annotation, :after => Time.now)
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if annotation is not an instance of GroupDocs::Document::Annotation' do
      lambda { described_class.get!('Annotation') }.should raise_error(ArgumentError)
    end

    it 'raises error if option :after is not an instance of Time' do
      lambda { described_class.get!(annotation, :after => 'Yesterday') }.should raise_error(ArgumentError)
    end

    it 'converts option :after to Unix timestamp' do
      time = Time.now
      time.should_receive(:to_i).and_return(1334125808)
      described_class.get!(annotation, :after => time)
    end

    it 'returns an array of GroupDocs::Document::Annotation::Reply objects' do
      replies = described_class.get!(annotation)
      replies.should be_an(Array)
      replies.each do |reply|
        reply.should be_a(GroupDocs::Document::Annotation::Reply)
      end
    end
  end

  it { should have_accessor(:annotation)     }
  it { should have_accessor(:text)           }
  it { should have_accessor(:guid)           }
  it { should have_accessor(:annotationGuid) }
  it { should have_accessor(:userGuid)       }
  it { should have_accessor(:userName)       }
  it { should have_accessor(:text)           }
  it { should have_accessor(:repliedOn)      }

  it { should alias_accessor(:annotation_guid, :annotationGuid) }
  it { should alias_accessor(:user_guid, :userGuid)             }
  it { should alias_accessor(:user_name, :userName)             }
  # Reply#replied_on is overwritten
  it { should have_alias(:replied_on=, :repliedOn=) }


  describe '#initialize' do
    it 'raises error if annotation is not specified' do
      lambda { described_class.new }.should raise_error(ArgumentError)
    end

    it 'raises error if annotation is not an instance of GroupDocs::Document::Annotation' do
      lambda { described_class.new(:annotation => '') }.should raise_error(ArgumentError)
    end
  end

  describe '#replied_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.replied_on = 1332950825000
      subject.replied_on.should == Time.at(1332950825)
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('annotation_replies_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'gets annotation guid' do
      subject.should_receive(:get_annotation_guid)
      subject.create!
    end

    it 'updates guid and annotation_guid with response' do
      lambda do
        subject.create!
      end.should change {
        subject.guid
        subject.annotation_guid
      }
    end
  end

  describe '#edit!' do
    before(:each) do
      mock_api_server('{ "result": {}, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.edit!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#remove!' do
    before(:each) do
      mock_api_server('{ "result": {}, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#get_annotation_guid' do
    it 'prefers annotation_guid over annotation.guid' do
      subject.annotation_guid = 'abc'
      subject.annotation.guid = 'def'
      subject.send(:get_annotation_guid).should == 'abc'
    end

    it 'returns annotation.guid if annotation_guid is not set' do
      subject.annotation.guid = 'def'
      subject.send(:get_annotation_guid).should == 'def'
    end
  end
end
