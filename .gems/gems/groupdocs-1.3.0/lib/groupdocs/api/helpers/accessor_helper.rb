module GroupDocs
  module Api
    module Helpers
      module Accessor

        #
        # Allows to easily alias accessors.
        #
        # @example
        #   class File < Api::Entity
        #     attr_accessor :fileName
        #     alias_accessor :file_name, :fileName
        #   end
        #   file = File.new
        #   file.file_name = "document"
        #   file.file_name
        #   #=> "document"
        #
        # @param [Symbol] new_name
        # @param [Symbol] old_name
        #
        def alias_accessor(new_name, old_name)
          alias_method :"#{new_name}",  :"#{old_name}"
          alias_method :"#{new_name}=", :"#{old_name}="
        end

      end # Accessor
    end # Helpers
  end # Api
end # GroupDocs
