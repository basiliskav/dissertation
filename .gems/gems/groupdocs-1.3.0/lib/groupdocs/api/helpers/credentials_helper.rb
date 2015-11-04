module GroupDocs
  module Api
    module Helpers
      module Credentials

        private

        #
        # Returns client ID from access hash or GroupDocs class variable.
        #
        # @return [String]
        # @raise [NoClientIdError] If Client ID hasn't been set yet, raise exception.
        # @api private
        #
        def client_id
          client_id = options[:access][:client_id] || GroupDocs.client_id
          client_id or raise NoClientIdError, 'Client ID has not been specified.'
        end

        #
        # Returns private key from access hash or GroupDocs class variable.
        #
        # @return [String]
        # @raise [NoPrivateKeyError] If private key hasn't been set yet, raise exception.
        # @api private
        #
        def private_key
          private_key = options[:access][:private_key] || GroupDocs.private_key
          private_key or raise NoPrivateKeyError, 'Private Key has not been specified.'
        end

      end # Credentials
    end # Helpers
  end # Api
end # GroupDocs
