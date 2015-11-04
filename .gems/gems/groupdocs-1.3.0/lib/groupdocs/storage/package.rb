module GroupDocs
  module Storage
    class Package < Api::Entity

      # @attr [String] name Package name
      attr_accessor :name
      # @attr [Array] objects Storage entities to be packed
      attr_accessor :objects

      #
      # Appends object to be packed.
      #
      # @param [GroupDocs::Storage::File, GroupDocs::Storage::Folder] object
      #
      def add(object)
        @objects ||= Array.new
        @objects << object
      end
      alias_method :<<, :add

      #
      # Creates package on server.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] URL of package for downloading
      #
      def create!(access = {})
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/packages/#{name}.zip"
          request[:request_body] = @objects.map(&:name)
        end.execute!

        json[:url]
      end

    end # Package
  end # Storage
end # GroupDocs
