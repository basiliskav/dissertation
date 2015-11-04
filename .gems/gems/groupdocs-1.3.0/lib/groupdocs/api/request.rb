module GroupDocs
  module Api
    class Request

      include Api::Helpers::Credentials
      include Api::Helpers::URL
      include Api::Helpers::REST

      # @attr_reader [RestClient::Resource] resource Entry point for all API requests
      attr_reader :resource
      # @attr [String] response Response from server in JSON format
      attr_accessor :response
      # @attr [Hash] options Hash of options
      attr_accessor :options
      # @attr [Hash] access Hash of access credentials
      attr_accessor :access

      #
      # Creates new API request.
      #
      # @example
      #   api = GroupDocs::Api::Request.new do |request|
      #     request[:method] = :POST
      #     request[:path] = "/storage/#{GroupDocs.client_id}/info"
      #   end
      #
      # @param [Hash] options
      # @option options [Symbol, String] :method HTTP method. One of :GET, :DOWNLOAD, :POST, :PUT or :DELETE.
      # @option options [String] :path Path to send request to
      # @option options [Hash] :headers Additional HTTP headers
      # @option options [Hash] :access Access credentials hash
      # @option options [Hash, String, Array, File] :request_body payload
      # @option options [Boolean] :plain Send payload as plain text (i.e. do not convert to JSON)
      #
      # @yieldparam [Hash] options
      #
      def initialize(options = {}, &blk)
        @options = options
        yield @options if block_given?
        @options[:access] ||= {}
        @resource = RestClient::Resource.new(GroupDocs.api_server)
      end

      #
      # Prepares, signs and returns absolute URL.
      #
      # It performs the following actions step by step:
      #   * Parses path (i.e. replaces client ID)
      #   * URL encodes path
      #   * Signs URL
      #
      # @return [String]
      #
      def prepare_and_sign_url
        unless @signed
          parse_path
          url_encode_path
          sign_url
          @signed = true
        end

        options[:path]
      end

      #
      # Executes API request to server.
      #
      # It performs the following actions step by step:
      #   * Prepends path with version if it's set
      #   * Prepares and signs URL
      #   * Prepare request (add headers, converts payload to JSON, etc.)
      #   * Sends request to server
      #   * Parses response
      #
      # @return [Hash, String] Parsed response
      #
      def execute!
        prepend_version
        prepare_and_sign_url
        prepare_request
        send_request
        parse_response
      end

    end # Request
  end # Api
end # GroupDocs
