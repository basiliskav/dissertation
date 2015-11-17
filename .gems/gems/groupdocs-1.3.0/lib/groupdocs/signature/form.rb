module GroupDocs
  class Signature::Form < Api::Entity

    include Signature::EntityMethods
    extend  Signature::ResourceMethods

    STATUSES = {
      :draft       => -1,
      :in_progress =>  1,
      :completed   =>  2,
      :archived    =>  3,
    }

    #
    # Returns a list of all forms.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :records How many items to list
    # @option options [Integer] :status_id Filter by status identifier
    # @option options [String] :document Filter by document GUID
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
        request[:path] = '/signature/{{client_id}}/forms'
      end
      api.add_params(options)
      json = api.execute!

      json[:forms].map do |form|
        new(form)
      end
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] name
    attr_accessor :name
    # @attr [String] ownerGuid
    attr_accessor :ownerGuid
    # @attr [String] templateGuid
    attr_accessor :templateGuid
    # @attr [String] createdTimeStamp
    attr_accessor :createdTimeStamp
    # @attr [String] statusDateTime
    attr_accessor :statusDateTime
    # @attr [Integer] documentsCount
    attr_accessor :documentsCount
    # @attr [Integer] documentsPages
    attr_accessor :documentsPages
    # @attr [Integer] participantsCount
    attr_accessor :participantsCount
    # @attr [Array] fieldsInFinalFileName
    attr_accessor :fieldsInFinalFileName
    # @attr [Boolean] canParticipantDownloadForm
    attr_accessor :canParticipantDownloadForm
    # @attr [Symbol] status
    attr_accessor :status

    # Human-readable accessors
    alias_accessor :owner_guid,                    :ownerGuid
    alias_accessor :template_guid,                 :templateGuid
    alias_accessor :created_time_stamp,            :createdTimeStamp
    alias_accessor :status_date_time,              :statusDateTime
    alias_accessor :documents_count,               :documentsCount
    alias_accessor :documents_pages,               :documentsPages
    alias_accessor :participants_count,            :participantsCount
    alias_accessor :fields_in_final_file_name,     :fieldsInFinalFileName
    alias_accessor :can_participant_download_form, :canParticipantDownloadForm

    #
    # Converts status to human-readable format.
    # @return [Symbol]
    #
    def status
      STATUSES.invert[@status]
    end

    #
    # Creates form.
    #
    # @example
    #   template = GroupDocs::Singature::Template!.get!('09662aab7187f31444476288ebaf7da4')
    #   form = GroupDocs::Signature::Form.new
    #   form.name = "Form"
    #   form.create! template
    #
    # @param [GroupDocs::Signature::Template] template
    # @param [Hash] options Hash of options
    # @option options [Integer] :assembly_id Assembly GUID to use
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if template is not GroupDocs::Signature::Template
    #
    def create!(template, options = {}, access = {})
      template.is_a?(GroupDocs::Signature::Template) or raise ArgumentError,
        "Template should be GroupDocs::Signature::Template object, received: #{template.inspect}"

      assembly_id = options.delete(:assembly_id)
      options[:assemblyId] = assembly_id if assembly_id

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/form'
        request[:request_body] = to_hash
      end
      api.add_params(options.merge(:name => name, :templateId => template.id))
      json = api.execute!

      self.id = json[:form][:id]
    end

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
        request[:path] = "/signature/{{client_id}}/forms/#{id}/documents"
      end.execute!

      json[:documents].map do |document|
        file = Storage::File.new(:guid => document[:documentId], :name => document[:name])
        Document.new(document.merge(:file => file))
      end
    end

    #
    # Publishes form.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def publish!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/forms/#{id}/publish"
      end.execute!
    end

    #
    # Completes form.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def complete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/forms/#{id}/complete"
      end.execute!
    end

    #
    # Archives completed form.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def archive!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/forms/#{id}/archive"
      end.execute!
    end

  end # Signature::Form
end # GroupDocs
