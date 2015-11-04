module GroupDocs
  class Signature
    #
    # Envelope and template entities share the same set of document methods.
    #
    # @see GroupDocs::Signature::Envelope
    # @see GroupDocs::Signature::Template
    #
    module DocumentMethods

      #
      # Returns documents array.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Document>]
      #
      def documents!(access = {})
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/documents"
        end.execute!

        json[:documents].map do |document|
          file = Storage::File.new(:guid => document[:documentId], :name => document[:name])
          Document.new(document.merge(:file => file))
        end
      end

      #
      # Adds document.
      #
      # @example
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = GroupDocs::Storage::Folder.list!.last.to_document
      #   template.add_document! document
      #
      # @example
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = GroupDocs::Storage::Folder.list!.last.to_document
      #   envelope.add_document! document
      #
      # @param [GroupDocs::Document] document
      # @param [Hash] options
      # @option options [Integer] :order Display order of the document
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if document is not GroupDocs::Document
      #
      def add_document!(document, options = {}, access = {})
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
          "Document should be GroupDocs::Document object, received: #{document.inspect}"

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/document/#{document.file.guid}"
        end
        api.add_params(options)
        api.execute!
      end

      #
      # Removes document.
      #
      # @example
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = template.documents!.first
      #   template.remove_document! document
      #
      # @example
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   envelope.remove_document! document
      #
      # @param [GroupDocs::Document] document
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if document is not GroupDocs::Document
      #
      def remove_document!(document, access = {})
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
          "Document should be GroupDocs::Document object, received: #{document.inspect}"

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/documents/#{document.file.guid}"
        end.execute!
      end

    end # DocumentMethods
  end # Signature
end # GroupDocs
