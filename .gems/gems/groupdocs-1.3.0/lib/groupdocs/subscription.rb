module GroupDocs
  class Subscription < Api::Entity

    require 'groupdocs/subscription/limit'

    LIMITS = {
      :annotations_limit       => 'AnnotationsLimit',
      :apicalls                => 'APICalls',
      :apiemails               => 'APIEmails',
      :assembly_limit          => 'AssemblyLimit',
      :branded                 => 'Branded',
      :comparison_limit        => 'ComparisonLimit',
      :conversion_limit        => 'ConversionLimit',
      :documents_limit         => 'DocumentsLimit',
      :document_history_limit  => 'DocumentHistoryLimit',
      :document_size_limit     => 'DocumentSizeLimit',
      :document_tokens_limit   => 'DocumentTokensLimit',
      :sharing_limit           => 'SharingLimit',
      :signature_limit         => 'SignatureLimit',
      :storage_space_limit     => 'StorageSpaceLimit',
      :users_limit             => 'UsersLimit',
    }

    #
    # Returns current subscription plan.
    #
    # @example
    #   GroupDocs::Subscription.current!.name
    #   #=> 'Free'
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Subscription]
    #
    def self.current!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/system/{{client_id}}/plan'
      end.execute!

      new(json)
    end

    #
    # Returns all subscription plans for family.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Subscription>]
    #
    def self.list!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/system/{{client_id}}/plans/groupdocs'
      end.execute!

      json[:metrics].map do |plan|
        new(plan)
      end
    end

    # @attr [Integer] Id
    attr_accessor :Id
    # @attr [String] Name
    attr_accessor :Name
    # @attr [Integer] PricingPlanId
    attr_accessor :PricingPlanId
    # @attr [Integer] Price
    attr_accessor :Price
    # @attr [String] CurrencyCode
    attr_accessor :CurrencyCode

    # Human-readable accessors
    alias_accessor :id,              :Id
    alias_accessor :name,            :Name
    alias_accessor :pricing_plan_id, :PricingPlanId
    alias_accessor :price,           :Price
    alias_accessor :currency_code,   :CurrencyCode

    # Compatibility with response JSON
    alias_method :ref_id=, :id=

    #
    # Dynamically generate accessors for existing subscription plan limits.
    #
    LIMITS.each do |snake, camel|
      # @attr [GroupDocs::Subscription::Limit] limit
      attr_accessor camel

      # Human-readable accessors
      alias_accessor snake, camel.to_sym

      #
      # Converts hash to subscription plan limit.
      # @return [GroupDocs::Subscription::Limit]
      #
      define_method(snake) do
        Limit.new(instance_variable_get(:"@#{camel}"))
      end
    end

  end # Subscription
end # GroupDocs
