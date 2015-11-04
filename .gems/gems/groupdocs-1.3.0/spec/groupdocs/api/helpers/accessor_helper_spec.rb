require 'spec_helper'

describe GroupDocs::Api::Helpers::Accessor do
  describe '.alias_accessor' do
    it 'aliases accessor to new name' do
      klass = GroupDocs::Api::Entity
      klass.class_eval <<-RUBY
        attr_accessor :guid
        alias_accessor :guiD, :guid
      RUBY
      subject = klass.new
      subject.should have_alias(:guiD,  :guid)
      subject.should have_alias(:guiD=, :guid=)
    end
  end
end
