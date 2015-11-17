require 'spec_helper'

describe GroupDocs::Api::Helpers::Status do

  subject do
    GroupDocs::Job.new
  end

  describe '#parse_status' do
    it 'returns underscored symbol if string is passed' do
      subject.send(:parse_status, 'InProgress').should == :in_progress
    end

    it 'returns capitalized string if symbol is passed' do
      subject.send(:parse_status, :in_progress).should == 'InProgress'
    end

    it 'raises error if argument is not string or symbol' do
      lambda { subject.send(:parse_status, 1) }.should raise_error(ArgumentError)
    end
  end
end
