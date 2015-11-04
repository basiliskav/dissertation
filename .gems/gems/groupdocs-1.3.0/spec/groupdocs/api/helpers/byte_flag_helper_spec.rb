require 'spec_helper'

describe GroupDocs::Api::Helpers::ByteFlag do
  subject do
    GroupDocs::User.new
  end

  let(:value_to_byte) { GroupDocs::Api::Helpers::AccessRights::ACCESS_RIGHTS }

  describe '#byte_from_array' do
    it 'returns correct byte flag' do
      values = value_to_byte.map { |k, _| k }
      subject.byte_from_array(values, value_to_byte).should == 15
    end
  end

  describe '#array_from_byte' do
    it 'returns correct byte flag' do
      values = subject.array_from_byte(15, value_to_byte)
      values.should =~ value_to_byte.map { |k, _| k }
    end
  end
end
