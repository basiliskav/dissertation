require 'spec_helper'

describe GroupDocs::Document::Rectangle do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:x)      }
  it { should have_accessor(:y)      }
  it { should have_accessor(:width)  }
  it { should have_accessor(:height) }

  it { should alias_accessor(:w, :width)  }
  it { should alias_accessor(:h, :height) }
end
