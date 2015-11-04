module GroupDocs
  class Signature
    #
    # Envelope and template entities share the same set of recipient methods.
    #
    # @see GroupDocs::Signature::Envelope
    # @see GroupDocs::Signature::Template
    #
    module RecipientMethods

      #
      # Returns recipients array.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Signature::Recipient>]
      #
      def recipients!(access = {})
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/recipients"
        end.execute!

        json[:recipients].map do |recipient|
          Signature::Recipient.new(recipient)
        end
      end

      #
      # Removes recipient.
      #
      # @example
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   recipient = template.recipients!.first
      #   template.remove_recipient! recipient
      #
      # @example
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   recipient = envelope.recipients!.first
      #   envelope.remove_recipient! recipient
      #
      # @param [GroupDocs::Signature::Recipient] recipient
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
      #
      def remove_recipient!(recipient, access = {})
        recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
          "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/recipients/#{recipient.id}"
        end.execute!
      end

    end # RecipientMethods
  end # Signature
end # GroupDocs
