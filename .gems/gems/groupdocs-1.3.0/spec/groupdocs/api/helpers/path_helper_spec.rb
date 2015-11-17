require 'spec_helper'

describe GroupDocs::Api::Helpers::Path do
  subject { GroupDocs::Storage::File.new }

  describe '#prepare_path' do
    it 'removes first / from string' do
      subject.send(:prepare_path, '/test').should == 'test'
    end

    it 'removes two or more / from string' do
      subject.send(:prepare_path, 'test1//test2///test3').should == 'test1/test2/test3'
    end
  end
end
