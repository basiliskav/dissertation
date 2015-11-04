module GroupDocs
  class Signature
    #
    # Envelope and template entities share the same set of fields.
    #
    # @see GroupDocs::Signature::Envelope
    # @see GroupDocs::Signature::Template
    #
    module EntityFields

      extend Api::Helpers::Accessor

      # @attr [String] id
      attr_accessor :id
      # @attr [String] name
      attr_accessor :name
      # @attr [Integer] ownerId
      attr_accessor :ownerId
      # @attr [String] ownerGuid
      attr_accessor :ownerGuid
      # @attr [String] reminderTime
      attr_accessor :reminderTime
      # @attr [Integer] stepExpireTime
      attr_accessor :stepExpireTime
      # @attr [Boolean] ownerShouldSign
      attr_accessor :ownerShouldSign
      # @attr [Boolean] orderedSignature
      attr_accessor :orderedSignature
      # @attr [String] emailSubject
      attr_accessor :emailSubject
      # @attr [String] emailBody
      attr_accessor :emailBody
      # @attr [Integer] documentsCount
      attr_accessor :documentsCount
      # @attr [Integer] documentsPages
      attr_accessor :documentsPages
      # @attr [Array<GroupDocs::Signature::Contact>] recipients
      attr_accessor :recipients

      # Human-readable accessors
      alias_accessor :owner_id,          :ownerId
      alias_accessor :owner_guid,        :ownerGuid
      alias_accessor :reminder_time,     :reminderTime
      alias_accessor :step_expire_time,  :stepExpireTime
      alias_accessor :owner_should_sign, :ownerShouldSign
      alias_accessor :ordered_signature, :orderedSignature
      alias_accessor :email_subject,     :emailSubject
      alias_accessor :email_body,        :emailBody
      alias_accessor :documents_count,   :documentsCount
      alias_accessor :documents_pages,   :documentsPages

      #
      # Converts each recipient to GroupDocs::Signature::Recipient object.
      # @param [Array<GroupDocs::Signature::Recipient, Hash>] recipients
      #
      def recipients=(recipients)
        if recipients
          @recipients = recipients.map do |recipient|
            if recipient.is_a?(GroupDocs::Signature::Recipient)
              recipient
            else
              Signature::Recipient.new(recipient)
            end
          end
        end
      end

      #
      # Returns true if owner should sign.
      # @return [Boolean]
      #
      def owner_should_sign
        @ownerShouldSign == 1 ? true : false
      end

      #
      # Returns ordered signature type.
      # @return [Symbol]
      #
      def ordered_signature
        @orderedSignature == 1 ? :parallel : :ordered
      end

    end # EntityFields
  end # Signature
end # GroupDocs
