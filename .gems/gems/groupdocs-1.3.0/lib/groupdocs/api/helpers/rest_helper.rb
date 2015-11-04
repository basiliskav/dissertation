require 'json'
require 'rest-client'

module GroupDocs
  module Api
    module Helpers
      module REST

        DEFAULT_HEADERS = {
          :accept             => 'application/json',
          :content_length     => 0,
          :groupdocs_referrer => "ruby/#{VERSION}"
        }

        private

        #
        # Prepares headers, method and payload for request.
        #
        # @api private
        #
        def prepare_request
          if options[:headers].is_a?(Hash)
            options[:headers].merge!(DEFAULT_HEADERS)
          else
            options[:headers] = DEFAULT_HEADERS.dup
          end

          options[:method] = options[:method].to_s.downcase.to_sym

          if options[:request_body] && !options[:request_body].is_a?(Object::File)
            unless options[:plain]
              options[:request_body] = options[:request_body].to_json
              options[:headers][:content_type]= 'application/json'
            end
            options[:headers][:content_length] = options[:request_body].length
          end
        end

        #
        # Sends request to API server.
        #
        # @api private
        #
        def send_request
          self.response = case options[:method]
            when :get, :download
              resource[options[:path]].get(options[:headers])
            when :post
              resource[options[:path]].post(options[:request_body], options[:headers])
            when :put
              resource[options[:path]].put(options[:request_body], options[:headers])
            when :delete
              resource[options[:path]].delete(options[:headers])
            else
              raise UnsupportedMethodError, "Unsupported HTTP method: #{options[:method].inspect}"
          end
        end

        #
        # Parses response from API server.
        #
        # @api private
        #
        def parse_response
          # for DOWNLOAD requests, just return response
          if options[:method] == :download
            response
          # for all other requests, parse JSON
          else
            json = JSON.parse(response, :symbolize_names => true)
            json[:status] == 'Ok' ? json[:result] : raise_bad_request_error(json)
          end
        end

        #
        # @raise [GroupDocs::BadResponseError]
        # @api private
        #
        def raise_bad_request_error(json)
          raise BadResponseError, json[:error_message]
        end

      end # REST
    end # Helpers
  end # Api
end # GroupDocs
