module GroupDocs
  class Signature::Contact < Api::Entity

    #
    # Returns a list of all contacts.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :records How many items to list
    # @option options [String] :firstName Filter by first name
    # @option options [String] :lastName Filter by last name
    # @option options [String] :email Filter by last name
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Contact>]
    #
    def self.get!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/contacts'
      end
      api.add_params(options)
      json = api.execute!

      json[:contacts].map do |contact|
        new(contact)
      end
    end

    #
    # Imports array of contacts.
    #
    # @example
    #   contact_one = GroupDocs::Signature::Contact.new
    #   contact_one.first_name = 'John'
    #   contact_one.last_name = 'Smith'
    #   contact_one.email = 'john@smith.com'
    #   contact_two = GroupDocs::Signature::Contact.new
    #   contact_two.first_name = 'Carla'
    #   contact_two.last_name = 'Smith'
    #   contact_two.email = 'carla@smith.com'
    #   GroupDocs::Signature::Contact.import!([contact_one, contact_two])
    #
    # @param [Array<GroupDocs::Signature::Contact>] contacts
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def self.import!(contacts, access = {})
      contacts.is_a?(Array) or raise ArgumentError, "Contacts should be array, received: #{contacts.inspect}"
      contacts.each do |contact|
        contact.is_a?(GroupDocs::Signature::Contact) or raise ArgumentError, "Contact should be GroupDocs::Signature::Contact, received: #{contact.inspect}"
      end

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/contacts'
        request[:request_body] = contacts.map { |contact| contact.to_hash }
      end.execute!
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] firstName
    attr_accessor :firstName
    # @attr [String] lastName
    attr_accessor :lastName
    # @attr [String] nickname
    attr_accessor :nickname
    # @attr [String] email
    attr_accessor :email
    # @attr [String] provider
    attr_accessor :provider

    # Human-readable accessors
    alias_accessor :first_name, :firstName
    alias_accessor :last_name,  :lastName

    #
    # Adds contact.
    #
    # @example
    #   contact = GroupDocs::Signature::Contact.new
    #   contact.first_name = 'John'
    #   contact.last_name = 'Smith'
    #   contact.email = 'john@smith.com'
    #   contact.add!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def add!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/contact'
        request[:request_body] = to_hash
      end.execute!

      self.id = json[:contact][:id]
    end

    #
    # Updates contact.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def update!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/contacts/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

    #
    # Deletes contact.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/contacts/#{id}"
      end.execute!
    end

  end # Signature::Contact
end # GroupDocs
