module GroupDocs
  class Questionnaire < Api::Entity

    require 'groupdocs/questionnaire/collector'
    require 'groupdocs/questionnaire/execution'
    require 'groupdocs/questionnaire/page'
    require 'groupdocs/questionnaire/question'

    include Api::Helpers::Status

    #
    # Returns an array of all questionnaires.
    #
    # @param [Hash] options Hash of options
    # @option options [Symbol] :status Filter questionnaires by status
    # @option options [Integer] :page_number Page to start with
    # @option options [Integer] :page_size How many items to list
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire>]
    #
    def self.all!(options = {}, access = {})
      if options[:status]
        # TODO find better way to parse status
        options[:status] = new.send(:parse_status, options[:status])
      end

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/merge/{{client_id}}/questionnaires'
      end
      api.add_params(options)
      json = api.execute!

      json[:questionnaires].map do |questionnaire|
        new(questionnaire)
      end
    end

    #
    # Returns questionnaire by identifier.
    #
    # @param [Integer] id
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire, nil]
    #
    def self.get!(id, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}"
      end.execute!

      new(json[:questionnaire])
    rescue RestClient::ResourceNotFound
      nil
    end

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [String] name
    attr_accessor :name
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [String] descr
    attr_accessor :descr
    # @attr [Array<GroupDocs::Questionnaire::Page>] pages
    attr_accessor :pages
    # @attr [Integer] resolved_executions
    attr_accessor :resolved_executions
    # @attr [Integer] assigned_questions
    attr_accessor :assigned_questions
    # @attr [Integer] total_questions
    attr_accessor :total_questions
    # @attr [Integer] modified
    attr_accessor :modified
    # @attr [Integer] expires
    attr_accessor :expires
    # @attr [Array<String>] document_ids
    attr_accessor :document_ids

    # Human-readable accessors
    alias_accessor :description, :descr

    #
    # Converts each page to GroupDocs::Questionnaire::Page object.
    #
    # @param [Array<GroupDocs::Questionnaire::Page, Hash>] pages
    #
    def pages=(pages)
      if pages
        @pages = pages.map do |page|
          if page.is_a?(GroupDocs::Questionnaire::Page)
            page
          else
            Questionnaire::Page.new(page)
          end
        end
      end
    end

    #
    # Converts status to human-readable format.
    #
    # @return [Symbol]
    #
    def status
      parse_status(@status)
    end

    #
    # Adds page to questionnaire.
    #
    # @param [GroupDocs::Questionnaire::Page] page
    # @raise [ArgumentError] if page is not GroupDocs::Questionnaire::Page object
    #
    def add_page(page)
      page.is_a?(GroupDocs::Questionnaire::Page) or raise ArgumentError,
        "Page should be GroupDocs::Questionnaire::Page object, received: #{page.inspect}"

      @pages ||= Array.new
      @pages << page
    end

    #
    # Creates questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/merge/{{client_id}}/questionnaires'
        request[:request_body] = to_hash
      end.execute!

      self.id = json[:questionnaire_id]
      self.guid = json[:questionnaire_guid]
      self.name = json[:adjusted_name]
    end

    #
    # Updates questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def update!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

    #
    # Removes questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def remove!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}"
      end.execute!
    # TODO: fix this in API - http://scotland.groupdocs.com/jira/browse/CORE-391
    rescue RestClient::BadRequest
      nil
    end

    #
    # Returns array of datasources for questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::DataSource>]
    #
    def datasources!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}/datasources"
      end.execute!

      json[:datasources].map do |datasource|
        DataSource.new(datasource)
      end
    end

    #
    # Returns an array of questionnaire executions.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire::Execution>]
    #
    def executions!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/#{guid}/executions"
      end.execute!

      json[:executions].map do |execution|
        Execution.new(execution)
      end
    end

    #
    # Returns an array of questionnaire collectors.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire::Collector>]
    #
    def collectors!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/#{guid}/collectors"
      end.execute!

      json[:collectors].map do |collector|
        collector.merge!(:questionnaire => self)
        Collector.new(collector)
      end
    end

    #
    # Returns questionnaire metadata.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire]
    #
    def metadata!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/#{guid}/metadata"
      end.execute!

      Questionnaire.new(json[:questionnaire])
    end

    #
    # Updates questionnaire metadata.
    #
    # @example
    #   questionnaire = GroupDocs::Questionnaire.get!(1)
    #   metadata = questionnaire.metadata!
    #   metadata.name = 'New questionnaire name'
    #   questionnaire.update_metadata! metadata
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if metadata is not GroupDocs::Questionnaire
    #
    def update_metadata!(metadata, access = {})
      metadata.is_a?(GroupDocs::Questionnaire) or raise ArgumentError,
        "Metadata should be GroupDocs::Questionnaire object, received: #{metadata.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/questionnaires/#{guid}/metadata"
        request[:request_body] = metadata.to_hash
      end.execute!
    end

    #
    # Returns an array of document fields for questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::Field>]
    #
    def fields!(access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/#{guid}/fields"
      end
      api.add_params(:include_geometry => true)
      json = api.execute!

      json[:fields].map do |field|
        Document::Field.new(field)
      end
    end

  end # Questionnaire
end # GroupDocs
