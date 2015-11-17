require 'spec_helper'

describe GroupDocs::User do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('user_profile_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::User object' do
      described_class.get!.should be_a(GroupDocs::User)
    end
  end

  describe '.update_account!' do
    before(:each) do
      mock_api_server(load_json('update_account'))
    end

    let!(:user) { GroupDocs::User.new }

    it 'accepts access credentials hash' do
      lambda do
        described_class.update_account!(user, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if user is not an instance of GroupDocs::User' do
      lambda { described_class.update_account!('user') }.should raise_error(ArgumentError)
    end

    it 'returns GroupDocs::User object' do
      described_class.update_account!(user).should be_a(GroupDocs::User)
    end
  end

  it { should have_accessor(:id)                 }
  it { should have_accessor(:guid)               }
  it { should have_accessor(:nickname)           }
  it { should have_accessor(:firstname)          }
  it { should have_accessor(:lastname)           }
  it { should have_accessor(:primary_email)      }
  it { should have_accessor(:private_key)        }
  it { should have_accessor(:password_salt)      }
  it { should have_accessor(:claimed_id)         }
  it { should have_accessor(:token)              }
  it { should have_accessor(:storage)            }
  it { should have_accessor(:photo)              }
  it { should have_accessor(:active)             }
  it { should have_accessor(:news_enabled)       }
  it { should have_accessor(:signed_up_on)       }
  it { should have_accessor(:color)              }
  it { should have_accessor(:customEmailMessage) }

  it { should alias_accessor(:first_name, :firstname)                    }
  it { should alias_accessor(:last_name, :lastname)                      }
  it { should alias_accessor(:custom_email_message, :customEmailMessage) }

  it { should have_alias(:pkey=, :private_key=)        }
  it { should have_alias(:pswd_salt=, :password_salt=) }
  it { should have_alias(:signedupOn=, :signed_up_on=) }

  describe '#access_rights' do
    it 'returns rights in human-readable format' do
      subject.instance_variable_set(:@access_rights, 15)
      subject.access_rights.should =~ [:export, :view, :proof, :download]
    end
  end

  describe '#access_rights=' do
    it 'converts rights in machine-readable format if array is passed' do
      subject.access_rights = %w(export view proof download)
      subject.instance_variable_get(:@access_rights).should == 15
    end

    it 'does nothing if not array is passed' do
      subject.access_rights = 15
      subject.instance_variable_get(:@access_rights).should == 15
    end
  end

  describe '#signed_up_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.signed_up_on = 1330450135000
      subject.signed_up_on.should == Time.at(1330450135)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server('{ "result": { "user_guid": "s8dfts8" }, "status": "Ok" }')
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

  describe '#users!' do
    before(:each) do
      mock_api_server(load_json('user_users_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.users!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::User objects' do
      users = subject.users!
      users.should be_an(Array)
      users.each do |user|
        user.should be_a(GroupDocs::User)
      end
    end
  end
end
