module GroupDocs
  module Api
    module Helpers
      module AccessRights

        include Api::Helpers::ByteFlag

        ACCESS_RIGHTS = {
          :export   => 1,
          :download => 2,
          :proof    => 4,
          :view     => 8,
        }

        private

        #
        # Converts shared link access rights array to byte flag.
        #
        # @param [Array<String, Symbol>] rights
        # @return [Integer]
        # @raise [ArgumentError] if rights is not an array
        # @raise [ArgumentError] if right is unknown
        # @api private
        #
        def convert_access_rights_to_byte(rights)
          rights.is_a?(Array) or raise ArgumentError, "Rights should be an array, received: #{rights.inspect}"
          rights = rights.map(&:to_sym)

          possible_rights = ACCESS_RIGHTS.map { |hash| hash.first }
          rights.each do |right|
            possible_rights.include?(right) or raise ArgumentError, "Unknown access right: #{rights.inspect}"
          end

          byte_from_array(rights, ACCESS_RIGHTS)
        end

        #
        # Converts byte flag to shared link access rights array.
        #
        # @param [Integer] rights
        # @return [Array<Symbol>]
        # @raise [ArgumentError] if rights is not integer
        # @api private
        #
        def convert_byte_to_access_rights(rights)
          rights.is_a?(Integer) or raise ArgumentError, "Rights should be an integer, received: #{rights.inspect}"
          array_from_byte(rights, ACCESS_RIGHTS)
        end

      end # AccessRights
    end # Helpers
  end # Api
end # GroupDocs
