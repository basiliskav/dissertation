require 'spec_helper'

describe GroupDocs::DataSource::Field do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:name)   }
  it { should have_accessor(:type)   }
  it { should have_accessor(:values) }

  describe '#type=' do
    it 'saves type in machine readable format if symbol is passed' do
      subject.type = :binary
      subject.instance_variable_get(:@type).should == 'Binary'
    end

    it 'does nothing if parameter is not symbol' do
      subject.type = 'Binary'
      subject.instance_variable_get(:@type).should == 'Binary'
    end
  end

  describe '#type' do
    it 'returns type in human-readable format' do
      subject.type = 'Binary'
      subject.type.should == :binary
    end
  end
end
