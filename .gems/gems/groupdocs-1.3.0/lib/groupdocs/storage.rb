require 'groupdocs/storage/folder'
require 'groupdocs/storage/file'
require 'groupdocs/storage/package'


module GroupDocs
  module Storage

    #
    # Returns hash of information about user's storage.
    #
    # @example
    #   GroupDocs::Storage.info!
    #   #=> { total_space: "1024 MB", available_space: "1020 MB", document_credits: 5000, available_credits: 4964 }
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Hash]
    #
    def self.info!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/storage/{{client_id}}'
      end.execute!

      {
        :total_space       => "#{json[:total_space] / 1048576} MB",
        :available_space   => "#{json[:avail_space] / 1048576} MB",
        :document_credits  => json[:doc_credits],
        :available_credits => json[:avail_credits]
      }
    end

  end # Storage
end # GroupDocs
