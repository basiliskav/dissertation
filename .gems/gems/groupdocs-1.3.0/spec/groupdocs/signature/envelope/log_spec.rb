require 'spec_helper'

describe GroupDocs::Signature::Envelope::Log do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:id)            }
  it { should have_accessor(:date)          }
  it { should have_accessor(:userName)      }
  it { should have_accessor(:action)        }
  it { should have_accessor(:remoteAddress) }

  it { should alias_accessor(:user_name, :userName)            }
  it { should alias_accessor(:remote_address,  :remoteAddress) }
end
