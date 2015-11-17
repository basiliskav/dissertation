require 'spec_helper'

describe GroupDocs::Api::Helpers::AccessMode do
  subject do
    GroupDocs::Storage::Folder.new
  end

  describe '#parse_access_mode' do
    it 'returns downcased symbol if string is passed' do
      subject.send(:parse_access_mode, 'Public').should == :public
    end

    it 'returns capitalized string if symbol is passed' do
      subject.send(:parse_access_mode, :public).should == 'Public'
    end

    it 'raises error if argument is not string or symbol' do
      lambda { subject.send(:parse_access_mode, 1) }.should raise_error(ArgumentError)
    end
  end
end
