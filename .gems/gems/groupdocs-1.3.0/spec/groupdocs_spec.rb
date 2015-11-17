require 'spec_helper'

describe GroupDocs do

  subject { described_class }
  let(:client_id)   { '07aaaf95f8eb33a4' }
  let(:private_key) { '5cb711b3a52ffc5d90ee8a0f79206f5a' }

  describe '.configure' do
    it { should respond_to(:configure) }

    it 'calls block for self' do
      subject.should_receive(:configure).and_yield(subject)
      subject.configure do |api|
        api.client_id   = client_id
        api.private_key = private_key
      end
    end

    it 'saves client ID for further access' do
      subject.should_receive(:client_id=).with(client_id).and_return(client_id)
      subject.configure do |api|
        api.client_id = client_id
      end
      subject.client_id.should == client_id
    end

    it 'saves private key for further access' do
      subject.should_receive(:private_key=).with(private_key).and_return(private_key)
      subject.configure do |api|
        api.private_key = private_key
      end
      subject.private_key.should == private_key
    end
  end

  it { should have_accessor(:client_id)   }
  it { should have_accessor(:private_key) }
  it { should have_accessor(:api_server)  }
  it { should have_accessor(:api_version) }

  describe '#api_server' do
    it 'returns default URL if it has not been overwritten' do
      subject.api_server.should == 'https://api.groupdocs.com'
    end

    it 'returns custom overwritten URL' do
      subject.api_server = 'https://dev-api.groupdocs.com'
      subject.api_server.should == 'https://dev-api.groupdocs.com'
    end
  end

  describe '#api_version' do
    it 'returns default version if it has not been overwritten' do
      subject.api_version.should == '2.0'
    end

    it 'returns custom overwritten version' do
      subject.api_version = '3.0'
      subject.api_version.should == '3.0'
    end
  end
end
