require 'spec_helper'

describe GroupDocs::Api::Helpers::REST do

  subject do
    GroupDocs::Api::Request.new(:method => :GET)
  end

  describe 'DEFAULT_HEADERS' do
    subject { described_class::DEFAULT_HEADERS }

    it 'includes "Accept: application/json"' do
      subject.should include(:accept => 'application/json')
    end

    it 'includes "Content-length: 0"' do
      subject.should include(:content_length => 0)
    end

    it 'includes Groupdocs-Referrer with SDK version' do
      subject.should include(:groupdocs_referrer => "ruby/#{GroupDocs::VERSION}")
    end
  end

  describe '#prepare_request' do
    it 'merges default headers with passed' do
      subject.options[:headers] = { :keep_alive => 300 }
      merged_headers = described_class::DEFAULT_HEADERS.merge(:keep_alive => 300)
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:headers] }.to(merged_headers)
    end

    it 'uses default headers when not passed' do
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:headers] }.to(described_class::DEFAULT_HEADERS)
    end

    it 'downcases HTTP method' do
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:method] }.to(:get)
    end

    it 'converts HTTP method to symbol' do
      subject.options[:method] = 'GET'
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:method] }.to(:get)
    end

    it 'coverts request body to JSON' do
      subject.options[:method] = :POST
      subject.options[:request_body] = { :body => 'test' }
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:request_body] }.to('{"body":"test"}')
    end

    it 'does not convert request body to JSON if payload is file' do
      file = Object::File.new(__FILE__, 'rb')
      subject.options[:method] = :POST
      subject.options[:request_body] = file
      subject.send(:prepare_request)
      subject.options[:request_body].should == file
    end

    it 'calculates and sets Content-length' do
      subject.options[:method] = :POST
      subject.options[:headers] = {}
      subject.options[:request_body] = { :body => 'test' }
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:headers][:content_length] }.to(15)
    end

    it 'sets Content-Type header if necessary' do
      subject.options[:method] = :POST
      subject.options[:headers] = {}
      subject.options[:request_body] = { :body => 'test' }
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:headers][:content_type] }.to('application/json')
    end

    it 'allows sending payload as plain text' do
      subject.options[:method] = :POST
      subject.options[:request_body] = 'test'
      subject.options[:plain] = true
      subject.send(:prepare_request)
      subject.options[:request_body].should == 'test'
      subject.options[:headers][:content_type].should_not == 'application/json'
    end
  end

  describe '#send_request' do
    %w(GET DOWNLOAD POST PUT DELETE).each do |method|
      it "sends HTTP #{method} request" do
        mock_api_server('{"status": "Ok"}')
        method = method.downcase.to_sym
        subject.options[:method] = method
        subject.options[:path] = '/folders'
        subject.options[:headers] = {}
        subject.send(:send_request)
      end
    end

    it 'raises error if incorrect method has been passed' do
      subject.options[:method] = :TEST
      lambda { subject.send(:send_request) }.should raise_error(GroupDocs::UnsupportedMethodError)
    end

    it 'saves response' do
      mock_api_server('{"status": "Ok"}')
      subject.options[:method] = :get
      subject.options[:path] = '/folders'
      subject.options[:headers] = {}
      lambda do
        subject.send(:send_request)
      end.should change(subject, :response).to('{"status": "Ok"}')
    end
  end

  describe '#parse_response' do
    it 'does not parse body if request method was DOWNLOAD' do
      subject.options[:method] = :download
      JSON.should_not_receive(:parse)
      lambda do
        subject.send(:parse_response)
      end.should_not change(subject, :response)
    end

    it 'returns JSON result key value' do
      mock_response('{"status": "Ok", "result": { "entities": [] }}')
      parsed_json = { :status => 'Ok', :result => { :entities => [] } }
      JSON.should_receive(:parse).with(subject.response, :symbolize_names => true).and_return(parsed_json)
      subject.send(:parse_response).should == { :entities => [] }
    end

    it 'raises error if response status is not "Ok"' do
      unparsed_json = '{"status": "Failed", "error_message": "The source path is not found."}'
      parsed_json   = { :status => "Failed", :error_message => "The source path is not found." }
      mock_response(unparsed_json)
      subject.should_receive(:raise_bad_request_error).with(parsed_json)
      subject.send(:parse_response)
    end
  end

  describe '#raise_bad_request_error' do
    let(:json) do
      { :status => 'Failed', :error_message => 'The source path is not found.' }
    end

    it 'raises error with message from response' do
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(GroupDocs::BadResponseError, 'The source path is not found.')
    end
  end
end
