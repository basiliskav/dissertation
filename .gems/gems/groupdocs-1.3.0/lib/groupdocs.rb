require 'groupdocs/version'
require 'groupdocs/errors'
require 'groupdocs/api'
require 'groupdocs/datasource'
require 'groupdocs/document'
require 'groupdocs/job'
require 'groupdocs/questionnaire'
require 'groupdocs/signature'
require 'groupdocs/storage'
require 'groupdocs/subscription'
require 'groupdocs/user'

module GroupDocs
  class << self

    # @attr [String] client_id Client ID
    attr_accessor :client_id

    # @attr [String] private_key Private key
    attr_accessor :private_key

    # @attr [String] api_server API server
    attr_accessor :api_server

    # @attr [String] api_version Version of API server
    attr_accessor :api_version

    #
    # Returns hostname of API server.
    # @return [String] API hostname. Default one if it has not been explicitly set
    #
    def api_server
      @api_server ||= 'https://api.groupdocs.com'
    end

    #
    # Returns version of API.
    # @return [String] API version. Default one if it has not been explicitly set
    #
    def api_version
      @api_version ||= '2.0'
    end

    #
    # Calls block for configuration of GroupDocs.
    #
    # @example
    #   GroupDocs.configure do |groupdocs|
    #     groupdocs.client_id = '07aaaf95f8eb33a4'
    #     groupdocs.private_key = '5cb711b3a52ffc5d90ee8a0f79206f5a'
    #     groupdocs.api_server = 'https://api.groupdocs.com'
    #     groupdocs.api_version = '2.0'
    #   end
    #
    # @yield [GroupDocs]
    #
    def configure(&blk)
      yield self
    end

  end # << self
end # GroupDocs
