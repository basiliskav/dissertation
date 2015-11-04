module GroupDocs
  class Signature
    #
    # Envelope and template entities share the same set of resource methods.
    #
    # @see GroupDocs::Signature::Form
    # @see GroupDocs::Signature::Envelope
    # @see GroupDocs::Signature::Template
    #
    module ResourceMethods

      #
      # Returns a list of resources.
      #
      # @example
      #   resources = GroupDocs::Signature::Envelope.resources!
      #   resources[:documents]
      #   #=> [#<GroupDocs::Document>]
      #   resources[:recipients]
      #   #=> [#<GroupDocs::Signature::Recipient>]
      #   resources[:dates]
      #   #=> ["2012-09-25T00:00:00.0000000"]
      #
      # @param [Hash] options Hash of options
      # @option options [Array<Integer>] :status_ids List of status identifiers to filter. Doesn't work for template
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Hash]
      #
      def resources!(options = {}, access = {})
        class_name = self.name.split('::').last.downcase

        # filter doesn't work for template
        unless class_name == 'template'
          ids = options.delete(:status_ids)
          options[:statusIds] = ids.join(?,) if ids
        end

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/signature/{{client_id}}/#{class_name}s/resources"
        end
        api.add_params(options)
        json = api.execute!

        resources = {}
        json.each do |key, value|
          resources[key] = case key
                           when :documents
                             value.map { |doc| Document.new(:file => Storage::File.new(doc)) }
                           when :recipients
                             value.map { |recipient| Signature::Recipient.new(recipient) }
                           else
                             value
                           end
        end

        resources
      end

    end # ResourceMethods
  end # Signature
end # GroupDocs
