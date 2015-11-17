module GroupDocs
  class Signature::List < Api::Entity

    #
    # Returns array of predefined lists.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::List>]
    #
    def self.get!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/lists'
      end.execute!

      json[:lists].map do |list|
        new(list)
      end
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] name
    attr_accessor :name
    # @attr [Array<String>] values
    attr_accessor :values
    # @attr [String] defaultValue
    attr_accessor :defaultValue

    # Human-readable accessors
    alias_accessor :default_value, :defaultValue

    #
    # Converts values to API compatible view.
    # @param [Array<String>, String] values
    #
    def values=(values)
      @values = values.is_a?(Array) ? values.join(';') : values
    end

    #
    # Returns values as array.
    # @return [Array<String>]
    #
    def values
      @values.split(';')
    end

    #
    # Adds predefined list.
    #
    # @example
    #   list = GroupDocs::Signature::List.new
    #   list.name = 'Cities'
    #   list.values = %w(London Paris)
    #   list.add!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def add!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/list'
        request[:request_body] = to_hash
      end.execute!

      self.id = json[:list][:id]
    end

    #
    # Deletes predefined list.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/lists/#{id}"
      end.execute!
    end

  end # Signature::List
end # GroupDocs
