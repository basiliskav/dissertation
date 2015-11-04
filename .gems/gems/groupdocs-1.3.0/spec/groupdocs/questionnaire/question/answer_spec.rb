require 'spec_helper'

describe GroupDocs::Questionnaire::Question::Answer do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:text)  }
  it { should have_accessor(:value) }
end
