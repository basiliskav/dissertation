module GroupDocs
  class Questionnaire::Execution < Api::Entity

    include Api::Helpers::Status

    #
    # Returns execution by identifier.
    #
    # @param [String] guid
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire::Execution, nil]
    #
    def self.get!(guid, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/executions/#{guid}"
      end.execute!

      new(json[:execution])
    rescue BadResponseError
      nil
    end

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [Integer] collector_id
    attr_accessor :collector_id
    # @attr [String] collector_guid
    attr_accessor :collector_guid
    # @attr [String] questionnaire_name
    attr_accessor :questionnaire_name
    # @attr [GroupDocs::User] owner
    attr_accessor :owner
    # @attr [GroupDocs::User] executive
    attr_accessor :executive
    # @attr [GroupDocs::User] approver
    attr_accessor :approver
    # @attr [Integer] datasource_id
    attr_accessor :datasource_id
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [Time] modified
    attr_accessor :modified
    # @attr [GroupDocs::Storage::File] document
    attr_accessor :document

    #
    # Converts status to human-readable format.
    # @return [Symbol]
    #
    def status
      parse_status(@status)
    end

    #
    # Converts timestamp which is return by API server to Time object.
    # @return [Time]
    #
    def modified
      Time.at(@modified / 1000)
    end

    #
    # Converts document to GroupDocs::Document object.
    # @param [Hash] options
    #
    def document=(options)
      if options.is_a?(Hash)
        options = GroupDocs::Storage::File.new(options)
      elsif options.is_a?(Document)
        options = options.file
      end

      @document = options
    end

    %w(owner executive approver).each do |method|
      #
      # Converts hash of user options to GroupDocs::User object.
      #
      # @param [GroupDocs::User, Hash] options
      #
      define_method(:"#{method}=") do |options|
        case options
        when User then instance_variable_set(:"@#{method}", options)
        when Hash then instance_variable_set(:"@#{method}", User.new(options))
        end
      end
    end

    #
    # Updates status of execution on server.
    #
    # @param [Symbol] status
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def set_status!(status, access = {})
      status = parse_status(status)

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/questionnaires/executions/#{id}/status"
        request[:request_body] = status
      end.execute!

      self.status = status
    end

    #
    # Updates execution on server.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def update!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/questionnaires/executions/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

    #
    # Deletes execution.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/merge/{{client_id}}/questionnaires/executions/#{id}"
      end.execute!
    end

    #
    # Creates new job to merge datasource into questionnaire collector execution.
    #
    # When you fill collector, execution for it creates. You can then fill this execution
    # (for example if you didn't answered all the questions at first).
    #
    # @param [GroupDocs::DataSource] datasource
    # @param [Hash] options
    # @option options [Boolean] :new_type New file format type
    # @option options [Boolean] :email_results Set to true if converted document should be emailed
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job]
    #
    # @raise [ArgumentError] if datasource is not GroupDocs::DataSource object
    #
    def fill!(datasource, options = {}, access = {})
      datasource.is_a?(GroupDocs::DataSource) or raise ArgumentError,
        "Datasource should be GroupDocs::DataSource object, received: #{datasource.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/questionnaires/executions/#{guid}/datasources/#{datasource.id}"
      end
      api.add_params(options)
      json = api.execute!

      Job.new(:id => json[:job_id])
    end

  end # Questionnaire::Execution
end # GroupDocs
