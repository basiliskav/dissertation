require 'mime/types'

module GroupDocs
  module Api
    module Helpers
      module MIME

        private

        #
        # Returns MIME type for file.
        # @api private
        #
        def mime_type(filepath)
          ::MIME::Types.type_for(filepath).first
        end

      end # MIME
    end # Helpers
  end # Api
end # GroupDocs
