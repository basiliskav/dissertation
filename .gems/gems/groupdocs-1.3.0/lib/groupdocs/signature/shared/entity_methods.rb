module GroupDocs
  class Signature
    #
    # Envelope and template entities share the same set of methods.
    #
    # @see GroupDocs::Signature::Form
    # @see GroupDocs::Signature::Envelope
    # @see GroupDocs::Signature::Template
    #
    module EntityMethods

      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        #
        # Returns template, envelope or form by its identifier.
        #
        # @param [String] id
        # @param [Hash] access Access credentials
        # @option access [String] :client_id
        # @option access [String] :private_key
        # @return [GroupDocs::Signature::Template, GroupDocs::Signature::Envelope, GroupDocs::Signature::Form]
        #
        def get!(id, access = {})
          class_name = self.name.split('::').last.downcase

          json = Api::Request.new do |request|
            request[:access] = access
            request[:method] = :GET
            request[:path] = "/signature/{{client_id}}/#{class_name}s/#{id}"
          end.execute!

          new(json[class_name.to_sym])
        end
      end # ClassMethods

      #
      # Creates template or envelope.
      #
      # @example Create new template
      #   template = GroupDocs::Signature::Template.new
      #   template.name = "Template"
      #   template.email_subject = "Sing this!"
      #   template.create!
      #
      # @example Create new envelope
      #   envelope = GroupDocs::Signature::Envelope.new
      #   envelope.name = "Envelope"
      #   envelope.email_subject = "Sing this!"
      #   envelope.create!
      #
      # @param [Hash] options Hash of options
      # @option options [Integer] :template_id Template GUID to use
      # @option options [Integer] :envelope_id Envelope GUID to use
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def create!(options = {}, access = {})
        template_id = options.delete(:template_id)
        envelope_id = options.delete(:envelope_id)
        options[:templateId] = template_id if template_id
        options[:envelopeId] = envelope_id if envelope_id

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/signature/{{client_id}}/#{class_name}"
          request[:request_body] = to_hash
        end
        api.add_params(options.merge(:name => name))
        json = api.execute!

        self.id = json[class_name.to_sym][:id]
      end

      #
      # Modifies template, envelope or form.
      #
      # @example Modify template
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   template.name = "Template"
      #   template.email_subject = "Sing this!"
      #   template.modify!
      #
      # @example Modify envelope
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   envelope.name = "Envelope"
      #   envelope.email_subject = "Sing this!"
      #   envelope.modify!
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def modify!(access = {})
        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}"
          request[:request_body] = to_hash
        end.execute!
      end

      #
      # Renames template, envelope or form.
      #
      # @param [String] name New template name
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def rename!(name, access = {})
        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}"
        end
        key = (class_name == 'form' ? :new_name : :name )
        api.add_params(key => name)
        api.execute!

        self.name = name
      end

      #
      # Deletes template, envelope or form.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def delete!(access = {})
        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}"
        end.execute!
      end

    end # EntityMethods
  end # Signature
end # GroupDocs
