module GroupDocs
  class Signature::Envelope < Api::Entity

    require 'groupdocs/signature/envelope/log'

    STATUSES = {
      :draft       => -1,
      :annotation  =>  0,
      :in_progress =>  1,
      :expired     =>  2,
      :canceled    =>  3,
      :failed      =>  4,
      :completed   =>  5,
      :archived    =>  6,
    }

    include Signature::DocumentMethods
    include Signature::EntityFields
    include Signature::EntityMethods
    include Signature::FieldMethods
    include Signature::RecipientMethods
    extend  Signature::ResourceMethods

    #
    # Returns a list of all envelopes.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :records How many items to list
    # @option options [Integer] :status_id Filter by status identifier
    # @option options [String] :document Filter by document GUID
    # @option options [String] :recipient Filter by recipient email
    # @option options [String] :date Filter by date
    # @option options [String] :name Filter by name
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Envelope>]
    #
    def self.all!(options = {}, access = {})
      status_id = options.delete(:status_id)
      options[:statusId] = status_id if status_id

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/envelopes'
      end
      api.add_params(options)
      json = api.execute!

      json[:envelopes].map do |envelope|
        new(envelope)
      end
    end

    #
    # Returns a list of all envelopes where user is recipient.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :records How many items to list
    # @option options [Integer] :statusId Filter by status identifier
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Envelope>]
    #
    def self.for_me!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/envelopes/recipient'
      end
      api.add_params(options)
      json = api.execute!

      json[:envelopes].map do |envelope|
        new(envelope)
      end
    end

    # @attr [String] creationDateTime
    attr_accessor :creationDateTime
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [String] statusDateTime
    attr_accessor :statusDateTime
    # @attr [Integer] envelopeExpireTime
    attr_accessor :envelopeExpireTime
    # @attr [Symbol] status
    attr_accessor :status

    # Human-readable accessors
    alias_accessor :creation_date_time,   :creationDateTime
    alias_accessor :status_date_time,     :statusDateTime
    alias_accessor :envelope_expire_time, :envelopeExpireTime

    #
    # Converts status to human-readable format.
    # @return [Symbol]
    #
    def status
      STATUSES.invert[@status]
    end

    #
    # Adds recipient to envelope.
    #
    # @example
    #   roles = GroupDocs::Signature::Role.get!
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   recipient = GroupDocs::Signature::Recipient.new
    #   recipient.email = 'john@smith.com'
    #   recipient.first_name = 'John'
    #   recipient.last_name = 'Smith'
    #   recipient.role_id = roles.detect { |role| role.name == "Signer" }.id
    #   envelope.add_recipient! recipient
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def add_recipient!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/recipient"
      end
      api.add_params(:email     => recipient.email,
                     :firstname => recipient.first_name,
                     :lastname  => recipient.last_name,
                     :role      => recipient.role_id,
                     :order     => recipient.order)
      api.execute!
    end

    #
    # Modify recipient of envelope.
    #
    # @example
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   recipient = envelope.recipients!.first
    #   recipient.first_name = 'Johnny'
    #   envelope.modify_recipient! recipient
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def modify_recipient!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/recipient/#{recipient.id}"
      end
      api.add_params(:email     => recipient.email,
                     :firstname => recipient.first_name,
                     :lastname  => recipient.last_name,
                     :role      => recipient.role_id,
                     :order     => recipient.order)
      api.execute!
    end

    #
    # Fills field with value.
    #
    # Value differs depending on field type. See examples below.
    #
    # @example Fill single line field
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   document = envelope.documents!.first
    #   recipient = envelope.recipients!.first
    #   field = envelope.fields!(document, recipient).first
    #   envelope.fill_field! "my_data", field, document, recipient
    #
    # @example Fill signature field
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   document = envelope.documents!.first
    #   recipient = envelope.recipients!.first
    #   field = envelope.fields!(document, recipient).first
    #   signature = GroupDocs::Signature.get!.first
    #   envelope.fill_field! signature, field, document, recipient
    #
    # @example Fill checkbox field
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   document = envelope.documents!.first
    #   recipient = envelope.recipients!.first
    #   field = envelope.fields!(document, recipient).first
    #   envelope.fill_field! false, field, document, recipient
    #
    # @param [String, Boolean, GroupDocs::Signature] value
    # @param [GroupDocs::Signature::Field] field
    # @param [GroupDocs::Document] document
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Signature::Field] filled field
    # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
    # @raise [ArgumentError] if document is not GroupDocs::Document
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def fill_field!(value, field, document, recipient, access = {})
      field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
        "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/documents/#{document.file.guid}/recipient/#{recipient.id}/field/#{field.id}"
      end

      type = field.field_type
      if type == :signature && value.is_a?(GroupDocs::Signature)
        api.add_params(:signatureId => value.id)
      else
        if type == :checkbox
          value = (value ? 'on' : 'off')
        end
        api.options[:request_body] = value
        api.options[:plain] = true
      end

      json = api.execute!
      Signature::Field.new(json[:field])
    end

    #
    # Signs envelope.
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def sign!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/recipient/#{recipient.id}/sign"
      end.execute!
    end

    #
    # Declines envelope.
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def decline!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/recipient/#{recipient.id}/decline"
      end.execute!
    end

    #
    # Downloads signed documents to given path.
    # If there is only one file in envelope, it's saved as PDF.
    # If there are two or more files in envelope, it's saved as ZIP.
    #
    # @param [String] path Directory to download file to
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [String] path to file
    #
    def signed_documents!(path, access = {})
      response = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DOWNLOAD
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/documents/get"
      end.execute!

      filepath = "#{path}/#{name}."
      if documents!.size == 1
        filepath << 'pdf'
      else
        filepath << 'zip'
      end

      Object::File.open(filepath, 'wb') do |file|
        file.write(response)
      end

      filepath
    end

    #
    # Returns a list of audit logs.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Envelope::Log>]
    #
    def logs!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/logs"
      end.execute!

      json[:logs].map do |log|
        Log.new(log)
      end
    end

    #
    # Sends envelope.
    #
    # @param [String] webhook URL to be hooked after envelope is completed
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def send!(webhook = nil, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/send"
        if webhook
          request[:request_body] = webhook
          request[:plain] = true
        end
      end.execute!
    end

    #
    # Archives completed envelope.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def archive!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/archive"
      end.execute!
    end

    #
    # Restarts expired envelope.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def restart!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/restart"
      end.execute!
    end

  end # Signature::Envelope
end # GroupDocs
