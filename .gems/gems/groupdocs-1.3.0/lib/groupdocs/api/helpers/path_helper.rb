module GroupDocs
  module Api
    module Helpers
      module Path

        #
        # Make helper methods accessible as class methods as well
        #
        def self.included(klass)
          klass.extend self
        end

        private

        #
        # Prepares path.
        # @param [String] path
        # @return [String]
        # @api private
        #
        def prepare_path(path)
          path.sub(%r(^/), '').gsub(%r(//+), '/')
        end

      end # Path
    end # Helpers
  end # Api
end # GroupDocs
