require 'spec_helper'

describe GroupDocs::Api::Helpers::Credentials do

  subject do
    GroupDocs::Api::Request.new(:method => :GET)
  end

  describe '#client_id' do
    it 'returns passed to method client ID' do
      subject.options[:access] = { :client_id => 'method_client_id' }
      subject.options[:access].should_receive(:[]).with(:client_id).and_return('method_client_id')
      subject.send(:client_id).should == 'method_client_id'
    end

    it 'returns GroupDocs.client_id if access has not been passed to method' do
      subject.options[:access] = {}
      GroupDocs.should_receive(:client_id).and_return('static_client_id')
      subject.send(:client_id).should == 'static_client_id'
    end

    it 'raises error if client ID has not been set' do
      subject.options[:access] = {}
      GroupDocs.client_id = nil
      lambda { subject.send(:client_id) }.should raise_error(GroupDocs::NoClientIdError)
    end
  end

  describe '#private_key' do
    it 'returns passed to method private key' do
      subject.options[:access] = { :private_key => 'method_private_key' }
      subject.options[:access].should_receive(:[]).with(:private_key).and_return('method_private_key')
      subject.send(:private_key).should == 'method_private_key'
    end

    it 'returns GroupDocs.private_key if access has not been passed to method' do
      subject.options[:access] = {}
      GroupDocs.should_receive(:private_key).and_return('static_private_key')
      subject.send(:private_key).should == 'static_private_key'
    end

    it 'raises error if private key has not been set' do
      subject.options[:access] = {}
      GroupDocs.private_key = nil
      lambda { subject.send(:private_key) }.should raise_error(GroupDocs::NoPrivateKeyError)
    end
  end
end
