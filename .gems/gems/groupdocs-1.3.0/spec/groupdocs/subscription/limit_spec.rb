require 'spec_helper'

describe GroupDocs::Subscription::Limit do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:Id)          }
  it { should have_accessor(:Min)         }
  it { should have_accessor(:Max)         }
  it { should have_accessor(:Description) }

  it { should alias_accessor(:id, :Id)                   }
  it { should alias_accessor(:min, :Min)                 }
  it { should alias_accessor(:max, :Max)                 }
  it { should alias_accessor(:description, :Description) }
end
