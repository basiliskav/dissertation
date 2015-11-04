module GroupDocs
  class Signature::Recipient < Api::Entity

    STATUSES = {
      :none       => -1,
      :waiting    =>  0,
      :notified   =>  1,
      :delegated  =>  2,
      :rejected   =>  3,
      :signed     =>  4,
    }

    # @attr [String] id
    attr_accessor :id
    # @attr [String] email
    attr_accessor :email
    # @attr [String] firstName
    attr_accessor :firstName
    # @attr [String] lastName
    attr_accessor :lastName
    # @attr [String] nickname
    attr_accessor :nickname
    # @attr [String] roleId
    attr_accessor :roleId
    # @attr [String] order
    attr_accessor :order
    # @attr [Symbol] status
    attr_accessor :status

    # Human-readable accessors
    alias_accessor :first_name, :firstName
    alias_accessor :last_name,  :lastName
    alias_accessor :role_id,    :roleId

    #
    # Converts status to human-readable format.
    # @return [Symbol]
    #
    def status
      STATUSES.invert[@status]
    end

  end # Signature::Recipient
end # GroupDocs
