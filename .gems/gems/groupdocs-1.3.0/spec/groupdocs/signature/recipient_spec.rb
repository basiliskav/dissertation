require 'spec_helper'

describe GroupDocs::Signature::Recipient do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:id)        }
  it { should have_accessor(:email)     }
  it { should have_accessor(:firstName) }
  it { should have_accessor(:lastName)  }
  it { should have_accessor(:nickname)  }
  it { should have_accessor(:roleId)    }
  it { should have_accessor(:order)     }
  it { should have_accessor(:status)    }

  it { should alias_accessor(:first_name, :firstName) }
  it { should alias_accessor(:last_name,  :lastName)  }
  it { should alias_accessor(:role_id,    :roleId)    }

  describe '#status' do
    it 'converts status to human-readable format' do
      subject.status = 1
      subject.status.should == :notified
    end
  end
end
