module GroupDocs
  class Signature
    #
    # Envelope and template entities share the same set of field methods.
    #
    # @see GroupDocs::Signature::Envelope
    # @see GroupDocs::Signature::Template
    #
    module FieldMethods

      #
      # Returns an array of fields for document and recipient.
      #
      # @example Get fields from template
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = template.documents!.first
      #   recipient = template.recipients!.first
      #   template.fields! document, recipient
      #
      # @example Get fields from envelope
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   recipient = envelope.recipients!.first
      #   envelope.fields! document, recipient
      #
      # @param [GroupDocs::Document] document
      # @param [GroupDocs::Signature::Recipient] recipient
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if document is not GroupDocs::Document
      # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
      #
      def fields!(document, recipient, access = {})
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
          "Document should be GroupDocs::Document object, received: #{document.inspect}"
        recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
          "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/fields"
        end
        api.add_params(:document => document.file.guid, :recipient => recipient.id)
        json = api.execute!

        json[:fields].map do |field|
          Signature::Field.new(field)
        end
      end

      #
      # Adds field for document and recipient.
      #
      # @example Add field to template
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   field = GroupDocs::Signature::Field.get!.detect { |f| f.name == "Signature" }
      #   field.location = { location_x: 0.1, location_y: 0.1, page: 1 }
      #   document = template.documents!.first
      #   recipient = template.recipients!.first
      #   template.add_field! field, document, recipient
      #
      # @example Add field to envelope
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   field = GroupDocs::Signature::Field.get!.detect { |f| f.name == "Signature" }
      #   field.location = { location_x: 0.1, location_y: 0.1, page: 1 }
      #   document = envelope.documents!.first
      #   recipient = envelope.recipients!.first
      #   envelope.add_field! field, document, recipient
      #
      # @param [GroupDocs::Signature::Field] field
      # @param [GroupDocs::Document] document
      # @param [GroupDocs::Signature::Recipient] recipient
      # @param [Hash] options
      # @option options [Boolean] :force_new_field Set to true to force new field create
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
      # @raise [ArgumentError] if document is not GroupDocs::Document
      # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
      # @raise [ArgumentError] if field does not specify location
      #
      def add_field!(field, document, recipient, opts = {}, access = {})
        field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
          "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
          "Document should be GroupDocs::Document object, received: #{document.inspect}"
        recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
          "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"
        field.location or raise ArgumentError,
          "You have to specify field location, received: #{field.location.inspect}"

        opts[:force_new_field] = true if opts[:force_new_field].nil?
        payload = field.to_hash # field itself
        payload.merge!(field.location.to_hash) # location should added in plain view (i.e. not "location": {...})
        payload.merge!(:forceNewField => opts[:force_new_field]) # create new field flag

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/documents/#{document.file.guid}/recipient/#{recipient.id}/field/#{field.id}"
          request[:request_body] = payload
        end.execute!
      end

      #
      # Modifies document field.
      #
      # @example Modify template field
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = template.documents!.first
      #   recipient = template.recipients!.first
      #   field = template.fields!(document, recipient).first
      #   field.name = "Field"
      #   template.modify_field! field, document
      #
      # @example Modify envelope field
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   recipient = envelope.recipients!.first
      #   field = envelope.fields!(document, recipient).first
      #   field.name = "Field"
      #   envelope.modify_field! field, document
      #
      # @param [GroupDocs::Signature::Field] field
      # @param [GroupDocs::Document] document
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
      # @raise [ArgumentError] if document is not GroupDocs::Document
      #
      def modify_field!(field, document, access = {})
        field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
          "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
          "Document should be GroupDocs::Document object, received: #{document.inspect}"

        # prepare payload
        payload = field.to_hash # field itself
        payload.delete(:locations) # remove locations array
        payload.merge!(field.locations.first.to_hash) # location should added in plain view (i.e. not "locations": [{...}])

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/documents/#{document.file.guid}/field/#{field.id}"
          request[:request_body] = payload
        end.execute!
      end

      #
      # Deletes field.
      #
      # @example Delete field from template
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = template.documents!.first
      #   recipient = template.recipients!.first
      #   field = template.fields!(document, recipient).first
      #   template.delete_field! field
      #
      # @example Delete field from envelope
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   recipient = envelope.recipients!.first
      #   field = envelope.fields!(document, recipient).first
      #   envelope.delete_field! field
      #
      # @param [GroupDocs::Signature::Field] field
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
      #
      def delete_field!(field, access = {})
        field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
          "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/fields/#{field.id}"
        end.execute!
      end

      #
      # Modifies field location.
      #
      # @example Modify field location in template
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = template.documents!.first
      #   recipient = template.recipients!.first
      #   field = template.fields!(document, recipient).first
      #   location = field.locations.first
      #   location.x = 0.123
      #   location.y = 0.123
      #   location.page = 2
      #   template.modify_field_location! location, field, document, recipient
      #
      # @example Modify field location in envelope
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   recipient = envelope.recipients!.first
      #   field = envelope.fields!(document, recipient).first
      #   location = field.locations.first
      #   location.x = 0.123
      #   location.y = 0.123
      #   location.page = 2
      #   envelope.modify_field_location! location, field, document, recipient
      #
      # @param [GroupDocs::Signature::Field::Location] location
      # @param [GroupDocs::Signature::Field] field
      # @param [GroupDocs::Document] document
      # @param [GroupDocs::Signature::Recipient] recipient
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if location is not GroupDocs::Signature::Field::Location
      # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
      # @raise [ArgumentError] if document is not GroupDocs::Document
      # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
      #
      def modify_field_location!(location, field, document, recipient, access = {})
        location.is_a?(GroupDocs::Signature::Field::Location) or raise ArgumentError,
          "Location should be GroupDocs::Signature::Field::Location object, received: #{location.inspect}"
        field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
          "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
          "Document should be GroupDocs::Document object, received: #{document.inspect}"
        recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
          "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/documents/#{document.file.guid}/recipient/#{recipient.id}/fields/#{field.id}/locations/#{location.id}"
          request[:request_body] = location.to_hash
        end.execute!
      end

      #
      # Deletes field location.
      #
      # @example Delete field location in template
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = template.documents!.first
      #   recipient = template.recipients!.first
      #   field = template.fields!(document, recipient).first
      #   location = field.locations.first
      #   template.delete_field_location! location, field
      #
      # @example Delete field location in envelope
      #   envelope = GroupDocs::Signature::Envelop.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   recipient = envelope.recipients!.first
      #   field = envelope.fields!(document, recipient).first
      #   location = field.locations.first
      #   envelope.delete_field_location! location, field
      #
      # @param [GroupDocs::Signature::Field::Location] location
      # @param [GroupDocs::Signature::Field] field
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if location is not GroupDocs::Signature::Field::Location
      # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
      #
      def delete_field_location!(location, field, access = {})
        location.is_a?(GroupDocs::Signature::Field::Location) or raise ArgumentError,
          "Location should be GroupDocs::Signature::Field::Location object, received: #{location.inspect}"
        field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
          "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/fields/#{field.id}/locations/#{location.id}"
        end.execute!
      end

    end # FieldMethods
  end # Signature
end # GroupDocs
