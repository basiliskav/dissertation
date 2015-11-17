module GroupDocs
  class Document::Rectangle < Api::Entity

    # @attr [Float] x
    attr_accessor :x
    # @attr [Float] y
    attr_accessor :y
    # @attr [Float] width
    attr_accessor :width
    # @attr [Float] height
    attr_accessor :height

    # Human-readable accessors
    alias_accessor :w, :width
    alias_accessor :h, :height

  end # Document::Rectangle
end # GroupDocs
