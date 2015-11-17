module GroupDocs
  class Document::Annotation::Reply < Api::Entity

    #
    # Return an array of replies for given annotation.
    #
    # @param [GroupDocs::Document::Annotation] annotation
    # @param [Hash] options
    # @option options [Time] :after
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::Annotation::Reply>]
    #
    # @raise [ArgumentError] If annotation is not passed or is not an instance of GroupDocs::Document::Annotation
    # @raise [ArgumentError] If :after option is passed but it's not an instance of Time
    #
    def self.get!(annotation, options = {}, access = {})
      annotation.is_a?(GroupDocs::Document::Annotation) or raise ArgumentError,
        "You have to pass GroupDocs::Document::Annotation object: #{annotation.inspect}."
      (options[:after] && !options[:after].is_a?(Time)) and raise ArgumentError,
        "Option :after should be an instance of Time, received: #{options[:after].inspect}"

      options[:after] = (options[:after].to_i * 1000) if options[:after]

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/ant/{{client_id}}/annotations/#{annotation.guid}/replies"
      end
      api.add_params(options)
      json = api.execute!

      json[:replies].map do |reply|
        reply.merge!(:annotation => annotation)
        Document::Annotation::Reply.new(reply)
      end
    end

    # @attr [GroupDocs::Document::Annotation] annotation
    attr_accessor :annotation
    # @attr [String] text
    attr_accessor :text
    # @attr [String] guid
    attr_accessor :guid
    # @attr [String] annotationGuid
    attr_accessor :annotationGuid
    # @attr [String] userGuid
    attr_accessor :userGuid
    # @attr [String] userName
    attr_accessor :userName
    # @attr [String] text
    attr_accessor :text
    # @attr [Time] repliedOn
    attr_accessor :repliedOn

    # Human-readable accessors
    alias_accessor :annotation_guid, :annotationGuid
    alias_accessor :user_guid,       :userGuid
    alias_accessor :user_name,       :userName
    alias_accessor :replied_on,      :repliedOn

    #
    # Creates new GroupDocs::Document::Annotation.
    #
    # @raise [ArgumentError] If annotation is not passed or is not an instance of GroupDocs::Document::Annotation
    #
    def initialize(options = {}, &blk)
      super(options, &blk)
      annotation.is_a?(GroupDocs::Document::Annotation) or raise ArgumentError,
        "You have to pass GroupDocs::Document::Annotation object: #{annotation.inspect}."
    end

    #
    # Converts timestamp which is return by API server to Time object.
    #
    # @return [Time]
    #
    def replied_on
      Time.at(@repliedOn / 1000)
    end

    #
    # Creates reply.
    #
    # @example
    #   document = GroupDocs::Storage::Folder.list!.first.to_document
    #   annotation = document.annotations!.first
    #   reply = GroupDocs::Document::Annotation::Reply.new(annotation: annotation)
    #   reply.text = "Reply text"
    #   reply.create!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/ant/{{client_id}}/annotations/#{get_annotation_guid}/replies"
        request[:request_body] = { :text => text }
      end.execute!

      self.guid            = json[:replyGuid]
      self.annotation_guid = json[:annotationGuid]
    end

    #
    # Edits reply.
    #
    # @example
    #   document = GroupDocs::Storage::Folder.list!.first.to_document
    #   annotation = document.annotations!.first
    #   reply = annotation.replies!.first
    #   reply.text = "New reply text"
    #   reply.edit!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def edit!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/replies/#{guid}"
        request[:request_body] = text
      end.execute!
    end

    #
    # Removes reply.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def remove!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/ant/{{client_id}}/replies/#{guid}"
      end.execute!
    end

    private

    #
    # Returns annotation guid.
    #
    # @return [String]
    #
    def get_annotation_guid
      annotation_guid || annotation.guid
    end

  end # Document::Annotation::Reply
end # GroupDocs
