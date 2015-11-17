require 'spec_helper'

describe GroupDocs::Document::Annotation do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::AccessMode

  subject do
    file = GroupDocs::Storage::File.new
    document = GroupDocs::Document.new(:file => file)
    described_class.new(:document => document)
  end

  it { should have_accessor(:document)           }
  it { should have_accessor(:id)                 }
  it { should have_accessor(:guid)               }
  it { should have_accessor(:sessionGuid)        }
  it { should have_accessor(:documentGuid)       }
  it { should have_accessor(:creatorGuid)        }
  it { should have_accessor(:replyGuid)          }
  it { should have_accessor(:createdOn)          }
  it { should have_accessor(:type)               }
  it { should have_accessor(:access)             }
  it { should have_accessor(:box)                }
  it { should have_accessor(:replies)            }
  it { should have_accessor(:annotationPosition) }

  it { should alias_accessor(:session_guid, :sessionGuid)   }
  it { should alias_accessor(:document_guid, :documentGuid) }
  it { should alias_accessor(:creator_guid, :creatorGuid)   }
  it { should alias_accessor(:reply_guid, :replyGuid)       }
  # Annotation#created_on is overwritten
  it { should have_alias(:created_on=, :createdOn=)                            }
  it { should alias_accessor(:annotation_position, :annotationPosition) }
  it { should alias_accessor(:position, :annotationPosition)            }

  it { should have_alias(:annotationGuid=, :guid=) }

  describe '#initialize' do
    it 'raises error if document is not specified' do
      lambda { described_class.new }.should raise_error(ArgumentError)
    end

    it 'raises error if document is not an instance of GroupDocs::Document' do
      lambda { described_class.new(:document => '') }.should raise_error(ArgumentError)
    end
  end

  describe '#type=' do
    it 'saves type in machine readable format if symbol is passed' do
      subject.type = :text_strikeout
      subject.instance_variable_get(:@type).should == 'TextStrikeout'
    end

    it 'does nothing if parameter is not symbol' do
      subject.type = 'Area'
      subject.instance_variable_get(:@type).should == 'Area'
    end

    it 'raises error if type is unknown' do
      lambda { subject.type = :unknown }.should raise_error(ArgumentError)
    end
  end

  describe '#type' do
    it 'returns type in human-readable format' do
      subject.type = 'TextStrikeout'
      subject.type.should == :text_strikeout
    end
  end

  describe '#access=' do
    it 'converts symbol to string if passed' do
      subject.access = :public
      subject.instance_variable_get(:@access).should == 'Public'
    end

    it 'does nothing if not a symbol is passed' do
      subject.access = 'Blah'
      subject.instance_variable_get(:@access).should == 'Blah'
    end
  end

  describe '#created_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.created_on = 1332950825000
      subject.created_on.should == Time.at(1332950825)
    end
  end

  describe '#box=' do
    it 'converts passed hash to GroupDocs::Document::Rectangle object' do
      subject.box = { :x => 0.90, :y => 0.05, :width => 0.06745, :height => 0.005967 }
      subject.box.should be_a(GroupDocs::Document::Rectangle)
      subject.box.x.should == 0.90
      subject.box.y.should == 0.05
      subject.box.w.should == 0.06745
      subject.box.h.should == 0.005967
    end
  end

  describe '#replies=' do
    it 'converts each reply to GroupDocs::Document::Annotation::Reply object if hash is passed' do
      subject.replies = [{  }]
      replies = subject.replies
      replies.should be_an(Array)
      replies.each do |reply|
        reply.should be_a(GroupDocs::Document::Annotation::Reply)
        reply.annotation.should == subject
      end
    end

    it 'saves each reply if it is GroupDocs::Document::Annotation::Reply object' do
      reply1 = GroupDocs::Document::Annotation::Reply.new(:annotation => subject)
      reply2 = GroupDocs::Document::Annotation::Reply.new(:annotation => subject)
      subject.replies = [reply1, reply2]
      subject.replies.should include(reply1)
      subject.replies.should include(reply2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.replies = nil
      end.should_not change(subject, :replies)
    end
  end

  describe '#add_reply' do
    it 'raises error if reply is not GroupDocs::Document::Annotation::Reply object' do
      lambda { subject.add_reply('Reply') }.should raise_error(ArgumentError)
    end

    it 'saves reply' do
      reply = GroupDocs::Document::Annotation::Reply.new(:annotation => subject)
      subject.add_reply(reply)
      subject.replies.should == [reply]
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('annotation_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash).and_return({})
      subject.create!
    end

    it 'updated self with response values' do
      lambda do
        subject.create!
      end.should change {
        subject.id
        subject.guid
        subject.document_guid
        subject.reply_guid
        subject.session_guid
      }
    end
  end

  describe '#remove!' do
    before(:each) do
      mock_api_server(load_json('annotation_remove'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#replies!' do
    it 'calls GroupDocs::Document::Annotation::Reply.get!' do
      GroupDocs::Document::Annotation::Reply.should_receive(:get!).with(subject, {}, {})
      subject.replies!
    end
  end

  describe '#move!' do
    before(:each) do
      mock_api_server(load_json('annotation_move'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.move!(10, 10, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'updates annotation position' do
      lambda do
        subject.move!(10, 10)
      end.should change(subject, :annotation_position).to(:x => 10, :y => 10)
    end
  end

  describe '#move_marker!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.move_marker!(10, 10, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'updates box coordinates if it is set' do
      subject.box = { :x => 1, :y => 2 }
      subject.move_marker! 10, 10
      subject.box.x.should == 10
      subject.box.y.should == 10
    end

    it 'creates box coordinates if it is not set' do
      subject.move_marker! 10, 10
      subject.box.x.should == 10
      subject.box.y.should == 10
    end
  end

  describe '#set_access!' do
    before(:each) do
      mock_api_server(load_json('annotation_access_set'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.set_access!(:private, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'updates annotation access mode' do
      subject.set_access!(:private)
      subject.access.should == :private
    end
  end
end
