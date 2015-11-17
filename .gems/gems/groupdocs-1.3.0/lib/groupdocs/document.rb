module GroupDocs
  class Document < Api::Entity

    require 'groupdocs/document/annotation'
    require 'groupdocs/document/change'
    require 'groupdocs/document/field'
    require 'groupdocs/document/metadata'
    require 'groupdocs/document/rectangle'
    require 'groupdocs/document/view'

    ACCESS_MODES = {
      :private    => 0,
      :restricted => 1,
      :inherited  => 2,
      :public     => 3,
    }

    include Api::Helpers::AccessMode
    include Api::Helpers::AccessRights
    include Api::Helpers::Status
    extend Api::Helpers::MIME

    #
    # Returns an array of views for all documents.
    #
    # @param [Hash] options
    # @option options [Integer] :page_index Page to start with
    # @option options [Integer] :page_size Total number of entries
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::View>]
    #
    def self.views!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/doc/{{client_id}}/views'
      end
      api.add_params(options)
      json = api.execute!

      json[:views].map do |view|
        Document::View.new(view)
      end
    end

    #
    # Returns an array of all templates (documents in "Templates" directory).
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document>]
    #
    def self.templates!(options = {}, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/merge/{{client_id}}/templates'
      end.execute!

      json[:templates].map do |template|
        template.merge!(:file => Storage::File.new(template))
        Document.new(template)
      end
    end

    #
    # Signs given documents with signatures.
    #
    # @example
    #   # prepare documents
    #   file_one = GroupDocs::Storage::File.new(name: 'document_one.doc', local_path: '~/Documents/document_one.doc')
    #   file_two = GroupDocs::Storage::File.new(name: 'document_one.pdf', local_path: '~/Documents/document_one.pdf')
    #   document_one = file_one.to_document
    #   document_two = file_two.to_document
    #   # prepare signatures
    #   signature_one = GroupDocs::Signature.new(name: 'John Smith', image_path: '~/Documents/signature_one.png')
    #   signature_two = GroupDocs::Signature.new(name: 'Sara Smith', image_path: '~/Documents/signature_two.png')
    #   signature_one.position = { top: 0.1, left: 0.07, width: 50, height: 50 }
    #   signature_two.position = { top: 0.2, left: 0.2, width: 100, height: 100 }
    #   # sign documents and download results
    #   signed_documents = GroupDocs::Document.sign_documents!([document_one, document_two], [signature_one, signature_two])
    #   signed_documents.each do |document|
    #     document.file.download! '~/Documents'
    #   end
    #
    # @param [Array<GroupDocs::Document>] documents Each document file should have "#name" and "#local_path"
    # @param [Array<GroupDocs::Signature>] signatures Each signature should have "#name", "#image_path" and "#position"
    #
    def self.sign_documents!(documents, signatures, options = {}, access = {})
      documents.each do |document|
        document.is_a?(Document) or raise ArgumentError, "Each document should be GroupDocs::Document object, received: #{document.inspect}"
        document.file.name       or raise ArgumentError, "Each document file should have name, received: #{document.file.name.inspect}"
        document.file.local_path or raise ArgumentError, "Each document file should have local_path, received: #{document.file.local_path.inspect}"
      end
      signatures.each do |signature|
        signature.is_a?(Signature) or raise ArgumentError, "Each signature should be GroupDocs::Signature object, received: #{signature.inspect}"
        signature.name             or raise ArgumentError, "Each signature should have name, received: #{signature.name.inspect}"
        signature.image_path       or raise ArgumentError, "Each signature should have image_path, received: #{signature.image_path.inspect}"
        signature.position         or raise ArgumentError, "Each signature should have position, received: #{signature.position.inspect}"
      end

      documents_to_sign = []
      documents.map(&:file).each do |file|
        document = { :name => file.name }
        contents = File.read(file.local_path)
        contents = Base64.strict_encode64(contents)
        document.merge!(:data => "data:#{mime_type(file.local_path)};base64,#{contents}")

        documents_to_sign << document
      end

      signers = []
      signatures.each do |signature|
        contents = File.read(signature.image_path)
        contents = Base64.strict_encode64(contents)
        signer = { :name => signature.name, :data => "data:#{mime_type(signature.image_path)};base64,#{contents}" }
        signer.merge!(signature.position)
        # place signature on is not implemented yet
        signer.merge!(:placeSignatureOn => nil)

        signers << signer
      end

      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/sign'
        request[:request_body] = { :documents => documents_to_sign, :signers => signers }
      end.execute!

      signed_documents = []
      json[:documents].each_with_index do |document, i|
        file = Storage::File.new(:guid => document[:documentId], :name => "#{documents[i].file.name}_signed.pdf")
        signed_documents << Document.new(:file => file)
      end

      signed_documents
    end

    #
    # Returns a document metadata by given path.
    #
    # @param [String] path Full path to document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::View>]
    #
    def self.metadata!(path, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{path}"
      end.execute!

      Document::MetaData.new do |metadata|
        metadata.id = json[:id]
        metadata.guid = json[:guid]
        metadata.page_count = json[:page_count]
        metadata.views_count = json[:views_count]
        if json[:last_view]
          metadata.last_view = json[:last_view]
          metadata.last_view.document = new(:file => Storage::File.new(json))
        end
      end
    end

    # @attr [GroupDocs::Storage::File] file
    attr_accessor :file
    # @attr [Time] process_date
    attr_accessor :process_date
    # @attr [Array<GroupDocs::Storage::File>] outputs
    attr_accessor :outputs
    # @attr [Array<Symbol>] output_formats
    attr_accessor :output_formats
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [Integer] order
    attr_accessor :order
    # @attr [Integer] field_count
    attr_accessor :field_count

    #
    # Coverts passed array of attributes hash to array of GroupDocs::Storage::File.
    #
    # @param [Array<Hash>] outputs Array of file attributes hashes
    #
    def outputs=(outputs)
      if outputs
        @outputs = outputs.map do |output|
          GroupDocs::Storage::File.new(output)
        end
      end
    end

    #
    # Returns output formats in human-readable format.
    #
    # @return [Array<Symbol>]
    #
    def output_formats
      @output_formats.split(',').map(&:to_sym)
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
    # Converts timestamp which is return by API server to Time object.
    #
    # @return [Time]
    #
    def process_date
      Time.at(@process_date / 1000)
    end

    # Compatibility with response JSON
    alias_method :proc_date=, :process_date=

    #
    # Creates new GroupDocs::Document.
    #
    # You should avoid creating documents directly. Instead, use #to_document
    # instance method of GroupDocs::Storage::File.
    #
    # @raise [ArgumentError] If file is not passed or is not an instance of GroupDocs::Storage::File
    #
    def initialize(options = {}, &blk)
      super(options, &blk)
      file.is_a?(GroupDocs::Storage::File) or raise ArgumentError,
        "You have to pass GroupDocs::Storage::File object: #{file.inspect}."
    end

    #
    # Returns array of URLs to images representing document pages.
    #
    # @example
    #   file = GroupDocs::Storage::Folder.list!.last
    #   document = file.to_document
    #   document.page_images! 1024, 768, first_page: 0, page_count: 1
    #
    # @param [Integer] width Image width
    # @param [Integer] height Image height
    # @param [Hash] options
    # @option options [Integer] :first_page Start page to return image for (starting with 0)
    # @option options [Integer] :page_count Number of pages to return image for
    # @option options [Integer] :quality
    # @option options [Boolean] :use_pdf
    # @option options [Boolean] :token
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<String>]
    #
    def page_images!(width, height, options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.guid}/pages/images/#{width}x#{height}/urls"
      end
      api.add_params(options)
      json = api.execute!

      json[:url]
    end

    #
    # Returns array of URLs to images representing document pages thumbnails.
    #
    # @example
    #   file = GroupDocs::Storage::Folder.list!.last
    #   document = file.to_document
    #   document.thumbnails! first_page: 0, page_count: 1, width: 1024
    #
    # @param [Hash] options
    # @option options [Integer] :page_number Start page to return image for (starting with 0)
    # @option options [Integer] :page_count Number of pages to return image for
    # @option options [Integer] :width
    # @option options [Integer] :quality
    # @option options [Boolean] :use_pdf
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<String>]
    #
    def thumbnails!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/doc/{{client_id}}/files/#{file.guid}/thumbnails"
      end
      api.add_params(options)
      json = api.execute!

      json[:image_urls]
    end

    #
    # Returns access mode of document.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Symbol] One of :private, :restricted or :public access modes
    #
    def access_mode!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/accessinfo"
      end.execute!

      parse_access_mode(json[:access])
    end

    #
    # Sets access mode of document.
    #
    # @param [Symbol] mode One of :private, :restricted or :public access modes
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Symbol] Set access mode
    #
    def access_mode_set!(mode, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/accessinfo"
      end
      api.add_params(:mode => ACCESS_MODES[mode])
      json = api.execute!

      parse_access_mode(json[:access])
    end
    # note that aliased version cannot accept access credentials hash
    alias_method :access_mode=, :access_mode_set!

    #
    # Returns array of file formats document can be converted to.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<Symbol>]
    #
    def formats!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/formats"
      end.execute!

      json[:types].map do |format|
        format.downcase.to_sym
      end
    end

    #
    # Returns document metadata.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Document::MetaData]
    #
    def metadata!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.guid}/metadata"
      end.execute!

      Document::MetaData.new do |metadata|
        metadata.id = json[:id]
        metadata.guid = json[:guid]
        metadata.page_count = json[:page_count]
        metadata.views_count = json[:views_count]
        if json[:last_view]
          metadata.last_view = json[:last_view]
          metadata.last_view.document = self
        end
      end
    end

    #
    # Returns an array of document fields.
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
        request[:path] = "/doc/{{client_id}}/files/#{file.guid}/fields"
      end
      api.add_params(:include_geometry => true)
      json = api.execute!

      json[:fields].map do |field|
        Document::Field.new(field)
      end
    end

    #
    # Returns an array of users a document is shared with.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def sharers!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/accessinfo"
      end.execute!

      json[:sharers].map do |user|
        User.new(user)
      end
    end

    #
    # Sets document sharers to given emails.
    #
    # If empty array or nil passed, clears sharers.
    #
    # @param [Array] emails List of email addresses to share with
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def sharers_set!(emails, access = {})
      if emails.nil? || emails.empty?
        sharers_clear!(access)
      else
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/doc/{{client_id}}/files/#{file.id}/sharers"
          request[:request_body] = emails
        end.execute!

        json[:shared_users].map do |user|
          User.new(user)
        end
      end
    end

    #
    # Clears sharers list.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return nil
    #
    def sharers_clear!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/sharers"
      end.execute![:shared_users]
    end

    #
    # Converts document to given format.
    #
    # @example
    #   document = GroupDocs::Storage::Folder.list!.first.to_document
    #   job = document.convert!(:docx)
    #   sleep(5) # wait for server to finish converting
    #   original_document = job.documents!.first
    #   converted_file = original_file.outputs.first
    #   converted_file.download!(File.dirname(__FILE__))
    #
    # @param [Symbol] format
    # @param [Hash] options
    # @option options [Boolean] :email_results Set to true if converted document should be emailed
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job] Created job
    #
    def convert!(format, options = {}, access = {})
      options.merge!(:new_type => format)

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/async/{{client_id}}/files/#{file.guid}"
      end
      api.add_params(options)
      json = api.execute!

      Job.new(:id => json[:job_id])
    end

    #
    # Creates new job to merge datasource into document.
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
    def datasource!(datasource, options = {}, access = {})
      datasource.is_a?(GroupDocs::DataSource) or raise ArgumentError,
        "Datasource should be GroupDocs::DataSource object, received: #{datasource.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/datasources/#{datasource.id}"
      end
      api.add_params(options)
      json = api.execute!

      Job.new(:id => json[:job_id])
    end

    #
    # Returns an array of questionnaires.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire>]
    #
    def questionnaires!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires"
      end.execute!

      json[:questionnaires].map do |questionnaire|
        Questionnaire.new(questionnaire)
      end
    end

    #
    # Adds questionnaire to document.
    #
    # @param [GroupDocs::Questionnaire] questionnaire
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    # @raise [ArgumentError] if questionnaire is not GroupDocs::Questionnaire object
    #
    def add_questionnaire!(questionnaire, access = {})
      questionnaire.is_a?(GroupDocs::Questionnaire) or raise ArgumentError,
        "Questionnaire should be GroupDocs::Questionnaire object, received: #{questionnaire.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires/#{questionnaire.id}"
      end.execute!
    end

    #
    # Creates questionnaire and adds it to document.
    #
    # @param [GroupDocs::Questionnaire] questionnaire
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire]
    #
    # @raise [ArgumentError] if questionnaire is not GroupDocs::Questionnaire object
    #
    def create_questionnaire!(questionnaire, access = {})
      questionnaire.is_a?(GroupDocs::Questionnaire) or raise ArgumentError,
        "Questionnaire should be GroupDocs::Questionnaire object, received: #{questionnaire.inspect}"

      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires"
        request[:request_body] = questionnaire.to_hash
      end.execute!

      questionnaire.id = json[:questionnaire_id]
      questionnaire
    end

    #
    # Detaches questionnaire from document.
    #
    # @param [GroupDocs::Questionnaire] questionnaire
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    # @raise [ArgumentError] if questionnaire is not GroupDocs::Questionnaire object
    #
    def remove_questionnaire!(questionnaire, access = {})
      questionnaire.is_a?(GroupDocs::Questionnaire) or raise ArgumentError,
        "Questionnaire should be GroupDocs::Questionnaire object, received: #{questionnaire.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires/#{questionnaire.id}"
      end.execute!
    end

    #
    # Returns an array of annotations.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::Annotation>]
    #
    def annotations!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/annotations"
      end.execute!

      if json[:annotations]
        json[:annotations].map do |annotation|
          annotation.merge!(:document => self)
          Document::Annotation.new(annotation)
        end
      else
        []
      end
    end

    #
    # Returns document details.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Hash]
    #
    def details!(access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/comparison/{{client_id}}/comparison/document"
      end
      api.add_params(:guid => file.guid)
      api.execute!
    end

    #
    # Schedules a job for comparing document with given.
    #
    # @param [GroupDocs::Document] document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job]
    #
    # @raise [ArgumentError] if document is not GroupDocs::Document object
    #
    def compare!(document, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/comparison/{{client_id}}/comparison/compare"
      end
      api.add_params(:source => file.guid, :target => document.file.guid)
      json = api.execute!

      Job.new(:id => json[:job_id])
    end

    #
    # Returns an array of changes in document.
    #
    # @example
    #   document_one = GroupDocs::Storage::Folder.list![0].to_document
    #   document_two = GroupDocs::Storage::Folder.list![1].to_document
    #   job = document_one.compare!(document_two)
    #   sleep(5) # wait for server to finish comparing
    #   result = job.documents!.first
    #   result.changes!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def changes!(access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/comparison/{{client_id}}/comparison/changes"
      end
      api.add_params(:resultFileId => file.guid)
      json = api.execute!

      json[:changes].map do |change|
        Document::Change.new(change)
      end
    end

    #
    # Returns document annotations collaborators.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def collaborators!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/collaborators"
      end.execute!

      json[:collaborators].map do |collaborator|
        User.new(collaborator)
      end
    end

    #
    # Sets document annotations collaborators to given emails.
    #
    # @param [Array<String>] emails List of collaborators' email addresses
    # @param [Integer] version Annotation version
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def set_collaborators!(emails, version = 1, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/version/#{version}/collaborators"
        request[:request_body] = emails
      end.execute!

      json[:collaborators].map do |collaborator|
        User.new(collaborator)
      end
    end

    #
    # Adds document annotations collaborator.
    #
    # @param [GroupDocs::User] collaborator
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def add_collaborator!(collaborator, access = {})
      collaborator.is_a?(GroupDocs::User) or raise ArgumentError,
        "Collaborator should be GroupDocs::User object, received: #{collaborator.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/collaborators"
        request[:request_body] = collaborator.to_hash
      end.execute!
    end

    #
    # Sets reviewers for document.
    #
    # @example Change reviewer rights
    #   reviewers = document.collaborators!
    #   reviewers.each do |reviewer|
    #     reviewer.access_rights = %w(view)
    #   end
    #   document.set_reviewers! reviewers
    #
    # @param [Array<GroupDocs::User>] reviewers
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def set_reviewers!(reviewers, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/reviewerRights"
        request[:request_body] = reviewers.map(&:to_hash)
      end.execute!
    end

    #
    # Returns an array of access rights for shared link.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<Symbol>]
    #
    def shared_link_access_rights!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/sharedLinkAccessRights"
      end.execute!

      if json[:accessRights]
        convert_byte_to_access_rights json[:accessRights]
      else
        []
      end
    end

    #
    # Sets access rights for shared link.
    #
    # @param [Array<Symbol>] rights
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<Symbol>]
    #
    def set_shared_link_access_rights!(rights, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/sharedLinkAccessRights"
        request[:request_body] = convert_access_rights_to_byte(rights)
      end.execute!
    end

    #
    # Sets session callback URL.
    #
    # @param [String] url Callback URL
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def set_session_callback!(url, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/sessionCallbackUrl"
        request[:request_body] = url
      end.execute!
    end

    #
    # Pass all unknown methods to file.
    #

    def method_missing(method, *args, &blk)
      file.respond_to?(method) ? file.send(method, *args, &blk) : super
    end

    def respond_to?(method)
      super or file.respond_to?(method)
    end

  end # Document
end # GroupDocs
