require 'spec_helper'

describe GroupDocs::Api::Entity do
  before(:each) do
    # make sure necessary attribute exist
    described_class.class_eval('attr_accessor :id, :test')
    subject.id = 1
  end

  describe '#to_hash' do
    it 'converts object attributes to hash' do
      subject.test = 'Test'
      subject.to_hash.should == { :id => 1, :test => 'Test' }
    end

    it 'converts attribute to hash if it is object' do
      object = described_class.new(:id => 1)
      object.should_receive(:to_hash).and_return({ :id => 1 })
      subject.test = object
      subject.to_hash.should == { :id => 1, :test => { :id => 1 } }
    end

    it 'converts attribute to hash if it is array' do
      object1 = described_class.new(:id => 1)
      object2 = described_class.new(:id => 2)
      object1.should_receive(:to_hash).and_return({ :id => 1 })
      object2.should_receive(:to_hash).and_return({ :id => 2 })
      subject.test = [object1, object2]
      subject.to_hash.should == { :id => 1, :test => [{ :id => 1 }, { :id => 2 }] }
    end
  end

  describe '#inspect' do
    it 'uses accessors instead of instance variables' do
      subject.instance_variable_set(:@test1, 1)
      subject.instance_variable_set(:@test2, 1)
      subject.instance_eval('def test1; { :fire => 1 }.invert[@test1] end')
      subject.instance_eval('def test2; { 1 => "fire" }[@test2] end')
      subject.inspect.should include('@test1=:fire')
      subject.inspect.should include('@test2="fire"')
    end

    it 'uses only not-nil instance variables' do
      subject.instance_variable_set(:@test, nil)
      subject.inspect.should_not include('@test')
    end
  end

  describe '#class_name' do
    it 'returns downcased class name' do
      object = GroupDocs::Storage::File.new
      object.send(:class_name).should == 'file'
    end
  end
end
