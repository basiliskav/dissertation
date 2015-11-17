require 'spec_helper'

describe GroupDocs::Api::Helpers::MIME do
  subject do
    GroupDocs::Signature.new
  end

  describe '#mime_type' do
    it 'returns first MIME type of file' do
      types = ['application/ruby']
      ::MIME::Types.should_receive(:type_for).with(__FILE__).and_return(types)
      types.should_receive(:first).and_return('application/ruby')
      subject.send(:mime_type, __FILE__)
    end
  end
end
