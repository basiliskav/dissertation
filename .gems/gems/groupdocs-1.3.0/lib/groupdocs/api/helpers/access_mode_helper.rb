module GroupDocs
  module Api
    module Helpers
      module AccessMode

        private

        #
        # Converts access mode from/to human-readable format.
        #
        # @param [String, Symbol] mode
        # @return [Symbol, String]
        # @raise [ArgumentError] if argument is not symbol/string
        # @api private
        #
        def parse_access_mode(mode)
          case mode
          when Symbol then mode.to_s.capitalize
          when String then mode.downcase.to_sym
          else raise ArgumentError, "Expected string/symbol, received: #{mode.class}"
          end
        end

      end # AccessMode
    end # Helpers
  end # Api
end # GroupDocs
