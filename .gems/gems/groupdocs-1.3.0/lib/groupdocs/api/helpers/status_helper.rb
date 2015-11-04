module GroupDocs
  module Api
    module Helpers
      module Status

        private

        #
        # Converts status from/to human-readable format.
        #
        # @param [String, Symbol] status
        # @return [Symbol, String]
        # @raise [ArgumentError] if argument is not symbol/string
        # @api private
        #
        def parse_status(status)
          case status
          when Symbol then status.to_s.camelize
          when String then status.underscore.to_sym
          else raise ArgumentError, "Expected string/symbol, received: #{status.class}"
          end
        end

      end # Status
    end # Helpers
  end # Api
end # GroupDocs
