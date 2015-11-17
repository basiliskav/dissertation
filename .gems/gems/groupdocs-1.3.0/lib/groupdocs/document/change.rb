module GroupDocs
  class Document::Change < Api::Entity

    # @attr [Integer] id
    attr_accessor :id
    # @attr [Symbol] type
    attr_accessor :type
    # @attr [GroupDocs::Document::Rectangle] box
    attr_accessor :box
    # @attr [String] text
    attr_accessor :text
    # @attr [Integer] page
    attr_accessor :page

    #
    # Returns type as symbol.
    #
    # @return [Symbol]
    #
    def type
      @type.to_sym
    end

    #
    # Coverts passed hash to GroupDocs::Document::Rectangle object.
    #
    # @param [Hash] options
    # @return [GroupDocs::Document::Rectangle]
    #
    def box=(options)
      @box = GroupDocs::Document::Rectangle.new(options)
    end

  end # Document::Change
end # GroupDocs
