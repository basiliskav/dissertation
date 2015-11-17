module GroupDocs
  module Api
    module Helpers
      module ByteFlag

        #
        # Converts array of values to byte flag using hash of value => byte.
        #
        # @param [Array<String, Symbol>] values
        # @param [Hash] value_byte_hash
        # @return [Integer]
        # @raise [ArgumentError] if values is not an array
        # @api private
        #
        def byte_from_array(values, value_byte_hash)
          flag = 0
          values.each do |value|
            flag += value_byte_hash[value]
          end

          flag
        end

        #
        # Converts byte flag to array of values using hash of value => byte.
        #
        # @param [Integer] byte
        # @param [Hash] value_byte_hash
        # @return [Integer]
        # @api private
        #
        def array_from_byte(byte, value_byte_hash)
          values = []

          value_byte_hash.sort { |a, b| b[1] <=> a[1] }.each do |value_byte|
            decreased_byte = byte - value_byte[1]
            if decreased_byte >= 0
              values << value_byte[0]
              byte = decreased_byte
            end
          end

          values
        end

      end # ByteFlag
    end # Helpers
  end # Api
end # GroupDocs
