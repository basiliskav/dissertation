module GroupDocs
  class Subscription::Limit < Api::Entity

    # @attr [Integer] Id
    attr_accessor :Id
    # @attr [Integer] Min
    attr_accessor :Min
    # @attr [Integer] Max
    attr_accessor :Max
    # @attr [String] Description
    attr_accessor :Description

    # Human-readable accessors
    alias_accessor :id,          :Id
    alias_accessor :min,         :Min
    alias_accessor :max,         :Max
    alias_accessor :description, :Description

  end # Subscription::Limit
end # GroupDocs
