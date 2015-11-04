require 'base64'
require 'uri'
require 'cgi'

module GroupDocs
  module Api
    module Helpers
      module URL

        #
        # Appends path with parameters.
        #
        # @param [Hash] params
        #
        def add_params(params)
          params.each do |param, value|
            value = value.join(',') if value.is_a?(Array)
            options[:path] << "#{separator}#{param}=#{value}"
          end
        end

        private

        #
        # Normalizes path replacing two or more slashes with one.
        #
        # @api private
        #
        def normalize_path
          options[:path].gsub!(%r(//+), '/')
        end

        #
        # Parses path replacing {{client_id}} with real one.
        #
        # @api private
        #
        def parse_path
          options[:path].sub!(/\{\{client_id\}\}/, client_id)
        end

        #
        # URL encodes path.
        #
        # @api private
        #
        def url_encode_path
          options[:path] = URI.escape(options[:path])
          options[:path].gsub! '+', '%2B'
        end

        #
        # Adds signature to path.
        #
        # @api private
        #
        def sign_url
          # calculate a hash of the path with private key
          hash = OpenSSL::Digest::Digest.new('sha1')
          hash = OpenSSL::HMAC.digest(hash, private_key, options[:path])
          # convert hash to base64
          hash = Base64.strict_encode64(hash)
          # remove trailing '='
          hash.gsub!(/=*$/, '')
          # URL encode hash
          hash = CGI.escape(hash)
          # covert all hexademical characters to upper case
          hash.gsub!(/(%[A-Fa-f0-9]{1,2})/) { |group| group.upcase }

          options[:path] << "#{separator}signature=#{hash}"
        end

        #
        # Returns separator for GET parameters.
        #
        # @return [String] Either ? or &
        # @api private
        #
        def separator
          options[:path].include?('?') ? '&' : '?'
        end

        #
        # Prepends path with version number if it's set.
        #
        # @api private
        #
        def prepend_version
          if GroupDocs.api_version
            options[:path] = "/v#{GroupDocs.api_version}#{options[:path]}"
          end
        end

      end # URL
    end # Helpers
  end # Api
end # GroupDocs
