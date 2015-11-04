require 'spec_helper'

describe GroupDocs::Api::Helpers::URL do

  subject do
    GroupDocs::Api::Request.new(:path => '/1/files/2?new_name=invoice.docx')
  end

  describe '#add_params' do
    it 'adds parameters to query' do
      subject.options[:path].should_receive(:<<).with('&param=value')
      subject.add_params({ :param => 'value' })
    end

    it 'joins values with comma if it is array' do
      subject.options[:path] = '/1/files/2'
      value = [1, 2]
      value.should_receive(:join).with(',').and_return('1,2')
      subject.add_params({ :param => value })
    end

    it 'determines correct URL separator' do
      subject.options[:path] = '/1/files/2'
      subject.should_receive(:separator)
      subject.add_params({ :param => 'value' })
    end
  end

  describe '#normalize_path' do
    it 'replaces two or more slashes with one' do
      subject.options[:path] = '/doc//folder///new////'
      subject.send(:normalize_path)
      subject.options[:path].should == '/doc/folder/new/'
    end
  end

  describe '#parse_path' do
    it 'replaces {{client_id}} with real client ID' do
      subject.options[:path] = '/doc/{{client_id}}/files/123'
      subject.should_receive(:client_id).and_return('real_client_id')
      subject.send(:parse_path)
      subject.options[:path].should == '/doc/real_client_id/files/123'
    end
  end

  describe '#url_encode_path' do
    it 'URL encodes path' do
      subject.options[:path] = '/folder/Test 123'
      subject.send(:url_encode_path)
      subject.options[:path].should == '/folder/Test%20123'
    end

    it 'replaces + with %2B' do
      subject.options[:path] = '/?email=john+1@smith.com'
      subject.send(:url_encode_path)
      subject.options[:path].should == '/?email=john%2B1@smith.com'
    end
  end

  describe '#sign_url' do
    it 'uses defined private key' do
      subject.should_receive(:private_key).and_return('e98ea443354183fd1fb434047232c687')
      subject.send(:sign_url)
    end

    it 'adds signature to path' do
      subject.options[:access] = { :private_key => 'e98ea443354183fd1fb434047232c687' }
      GroupDocs.stub(:api_version => nil)
      subject.send(:sign_url)
      subject.options[:path].should == '/1/files/2?new_name=invoice.docx&signature=gw%2BLupOB3krtliSSM0dvUBSznJY'
    end

    it 'determines correct URL separator' do
      subject.options[:access] = { :private_key => 'e98ea443354183fd1fb434047232c687' }
      subject.should_receive(:separator)
      subject.send(:sign_url)
    end
  end

  describe '#separator' do
    it 'returns ? if URL has no parameters' do
      subject.options[:path] = '/1/files/2'
      subject.send(:separator).should == '?'
    end

    it 'returns & if URL has parameters' do
      subject.send(:separator).should == '&'
    end
  end

  describe '#prepend_version' do
    it 'does not modify URL if API version is not specified' do
      GroupDocs.stub(:api_version => nil)
      subject.options.should_not_receive(:[]=).with(:path, '/v2.0/1/files/2?new_name=invoice.docx')
      subject.send(:prepend_version)
    end

    it 'prepends API version number' do
      GroupDocs.stub(:api_version => '2.0')
      path = '/1/files/2?new_name=invoice.docx'
      subject = GroupDocs::Api::Request.new(:path => path)
      subject.options.should_receive(:[]=).with(:path, "/v2.0#{path}").and_return("/v2.0#{path}")
      subject.send(:prepend_version)
    end
  end
end
