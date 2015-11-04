require 'spec_helper'

describe GroupDocs::Storage::Package do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:name)    }
  it { should have_accessor(:objects) }

  describe '#add' do
    it 'adds objects to be packed later' do
      subject.objects = ['object 1']
      subject.objects.should_receive(:<<).with('object 2')
      subject.add('object 2')
    end

    it 'is aliased to #<<' do
      subject.should have_alias(:<<, :add)
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('package_create'))
      subject.objects = [stub(:name => 'object 1')]
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns URL for package downloading' do
      subject.create!.should be_a(String)
    end
  end
end
