module GroupDocs
  class Signature::Field < Api::Entity

    require 'groupdocs/signature/field/location'

    FIELD_TYPES = {
      :signature    => 1,
      :single_line  => 2,
      :multiline    => 3,
      :date         => 4,
      :dropdown     => 5,
      :checkbox     => 6,
    }

    #
    # Returns array of predefined lists.
    #
    # @param [Hash] options Hash of options
    # @option options [String] :id Filter by identifier
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Field>]
    #
    def self.get!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/fields'
      end
      api.add_params(options)
      json = api.execute!

      json[:fields].map do |field|
        new(field)
      end
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] templateId
    attr_accessor :templateId
    # @attr [String] recipientId
    attr_accessor :recipientId
    # @attr [String] signatureFieldId
    attr_accessor :signatureFieldId
    # @attr [String] name
    attr_accessor :name
    # @attr [Integer] graphSizeW
    attr_accessor :graphSizeW
    # @attr [Integer] graphSizeH
    attr_accessor :graphSizeH
    # @attr [String] getDataFrom
    attr_accessor :getDataFrom
    # @attr [String] regularExpression
    attr_accessor :regularExpression
    # @attr [String] fontName
    attr_accessor :fontName
    # @attr [String] fontColor
    attr_accessor :fontColor
    # @attr [Integer] fontSize
    attr_accessor :fontSize
    # @attr [Boolean] fontBold
    attr_accessor :fontBold
    # @attr [Boolean] fontItalic
    attr_accessor :fontItalic
    # @attr [Boolean] fontUnderline
    attr_accessor :fontUnderline
    # @attr [Boolean] isSystem
    attr_accessor :isSystem
    # @attr [Boolean] mandatory
    attr_accessor :mandatory
    # @attr [Symbol] fieldType
    attr_accessor :fieldType
    # @attr [Boolean] acceptableValues
    attr_accessor :acceptableValues
    # @attr [String] defaultValue
    attr_accessor :defaultValue
    # @attr [String] tooltip
    attr_accessor :tooltip
    # @attr [Integer] input
    attr_accessor :input
    # @attr [Integer] order
    attr_accessor :order
    # @attr [String] textRows
    attr_accessor :textRows
    # @attr [String] textColumns
    attr_accessor :textColumns
    # @attr [GroupDocs::Signature::Field::Location] location
    attr_accessor :location
    # @attr [Array<GroupDocs::Signature::Field::Location>] locations
    attr_accessor :locations

    # Human-readable accessors
    alias_accessor :template_id,        :templateId
    alias_accessor :recipient_id,       :recipientId
    alias_accessor :signature_field_id, :signatureFieldId
    alias_accessor :graph_size_w,       :graphSizeW
    alias_accessor :graph_size_w,       :graphSizeW
    alias_accessor :graph_size_width,   :graphSizeW
    alias_accessor :graph_size_h,       :graphSizeH
    alias_accessor :graph_size_height,  :graphSizeH
    alias_accessor :get_data_from,      :getDataFrom
    alias_accessor :regular_expression, :regularExpression
    alias_accessor :font_name,          :fontName
    alias_accessor :font_color,         :fontColor
    alias_accessor :font_size,          :fontSize
    alias_accessor :font_bold,          :fontBold
    alias_accessor :font_italic,        :fontItalic
    alias_accessor :font_underline,     :fontUnderline
    alias_accessor :is_system,          :isSystem
    alias_accessor :acceptable_values,  :acceptableValues
    alias_accessor :default_value,      :defaultValue
    alias_accessor :text_rows,          :textRows
    alias_accessor :text_columns,       :textColumns

    #
    # Converts location to GroupDocs::Signature::Field::Location object.
    #
    # @param [GroupDocs::Signature::Field::Location, Hash] location
    #
    def location=(location)
      if location
        @location = (location.is_a?(GroupDocs::Signature::Field::Location) ? location : Signature::Field::Location.new(location))
        locations ? locations << @location : self.locations = [@location]
      end
    end

    #
    # Converts each location to GroupDocs::Signature::Field::Location object.
    #
    # @param [Array<GroupDocs::Signature::Field::Location, Hash>] locations
    #
    def locations=(locations)
      if locations
        @locations = locations.map do |location|
          if location.is_a?(GroupDocs::Signature::Field::Location)
            location
          else
            Signature::Field::Location.new(location)
          end
        end
      end
    end

    #
    # Saves field type in machine-readable format.
    # @param [Symbol, Integer] type
    #
    def field_type=(type)
      if type.is_a?(Symbol)
        type = FIELD_TYPES[type]
      end

      @fieldType = type
    end
    alias_method :type=, :field_type=

    #
    # Returns field type in human-readable format.
    # @return [Symbol]
    #
    def field_type
      FIELD_TYPES.invert[@fieldType]
    end
    alias_method :type, :field_type

    #
    # Creates signature field.
    #
    # @example
    #   field = GroupDocs::Signature::Field.new
    #   field.name = 'Field'
    #   field.create!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/field'
        request[:request_body] = to_hash
      end.execute!

      self.id = json[:field][:id]
    end

    #
    # Modifies signature field.
    #
    # @example
    #   field = GroupDocs::Signature::Field.get!.first
    #   field.name = 'Field'
    #   field.modify!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def modify!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/fields/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

    #
    # Deletes signature field.
    #
    # @example Remove all created fields
    #   fields = GroupDocs::Signature::Field.get!.select { |field| !field.is_system }
    #   fields.each { |field| field.delete! }
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/fields/#{id}"
      end.execute!
    end

  end # Signature::Field
end # GroupDocs
