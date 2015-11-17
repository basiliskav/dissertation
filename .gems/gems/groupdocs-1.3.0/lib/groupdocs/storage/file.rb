module GroupDocs
  module Storage
    class File < Api::Entity

      include Api::Helpers::AccessMode
      include Api::Helpers::Path

      DOCUMENT_TYPES = %w(Undefined Cells Words Slides Pdf Html Image)

      #
      # Uploads file to API server.
      #
      # @example Upload file to root directory
      #   GroupDocs::Storage::File.upload!('resume.pdf')
      #
      # @example Upload file to specific directory
      #   GroupDocs::Storage::File.upload!('resume.pdf', path: 'folder1')
      #
      # @example Upload and rename file
      #   GroupDocs::Storage::File.upload!('resume.pdf', name: 'cv.pdf')
      #
      # @example Upload file with description
      #   GroupDocs::Storage::File.upload!('resume.pdf', description: 'Resume')
      #
      # @param [String] filepath Path to file to be uploaded
      # @param [Hash] options
      # @option options [String] path Folder path to upload to
      # @option options [String] name Name of file to be renamed
      # @option options [String] description File description
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File]
      #
      def self.upload!(filepath, options = {}, access = {})
        options[:path] ||= ''
        options[:name] ||= Object::File.basename(filepath)
        path = prepare_path("#{options[:path]}/#{options[:name]}")

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/folders/#{path}"
          request[:request_body] = Object::File.new(filepath, 'rb')
        end
        api.add_params(:description => options[:description]) if options[:description]
        json = api.execute!

        Storage::File.new(json)
      end

      #
      # Uploads web page as file.
      #
      # @param [String] url
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File]
      #
      def self.upload_web!(url, access = {})
        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = '/storage/{{client_id}}/urls'
        end
        api.add_params(:url => url)
        json = api.execute!

        Storage::File.new(json)
      end

      # @attr [Integer] id
      attr_accessor :id
      # @attr [String] guid
      attr_accessor :guid
      # @attr [Integer] size
      attr_accessor :size
      # @attr [Boolean] known
      attr_accessor :known
      # @attr [String] thumbnail
      attr_accessor :thumbnail
      # @attr [Time] created_on
      attr_accessor :created_on
      # @attr [Time] modified_on
      attr_accessor :modified_on
      # @attr [String] url
      attr_accessor :url
      # @attr [String] name
      attr_accessor :name
      # @attr [Integer] version
      attr_accessor :version
      # @attr [Symbol] type
      attr_accessor :type
      # @attr [Symbol] file_type
      attr_accessor :file_type
      # @attr [Symbol] access
      attr_accessor :access
      # @attr [String] path
      attr_accessor :path
      # @attr [String] local_path
      attr_accessor :local_path

      # Compatibility with response JSON
      alias_method :adj_name=, :name=

      #
      # Updates type with machine-readable format.
      #
      # @param [Symbol] type
      # @raise [ArgumentError] if type is unknown
      #
      def type=(type)
        if type.is_a?(Symbol)
          type = type.to_s.capitalize
          DOCUMENT_TYPES.include?(type) or raise ArgumentError, "Unknown type: #{type.inspect}"
        end

        @type = type
      end

      #
      # Returns type in human-readable format.
      #
      # @return [Symbol]
      #
      def type
        @type.downcase.to_sym
      end

      #
      # Returns file type in human-readable format.
      #
      # @return [Symbol]
      #
      def file_type
        @file_type.downcase.to_sym
      end

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def created_on
        Time.at(@created_on / 1000)
      end

      #
      # Converts access mode to human-readable format.
      #
      # @return [Symbol]
      #
      def access
        parse_access_mode(@access)
      end

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def modified_on
        Time.at(@modified_on / 1000)
      end

      #
      # Downloads file to given path.
      #
      # @param [String] path Directory to download file to
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] Path to downloaded file
      #
      def download!(path, access = {})
        response = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DOWNLOAD
          request[:path] = "/storage/{{client_id}}/files/#{guid}"
        end.execute!

        filepath = "#{path}/#{name}"
        Object::File.open(filepath, 'wb') do |file|
          file.write(response)
        end

        filepath
      end

      #
      # Moves file to given path.
      #
      # @param [String] path
      # @param [Hash] options
      # @option options [String] name
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Moved to file
      #
      def move!(path, options = {}, access = {})
        options[:name] ||= name
        path = prepare_path("#{path}/#{options[:name]}")

        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Move' => id }
          request[:path] = "/storage/{{client_id}}/files/#{path}"
        end.execute!

        Storage::File.new(json[:dst_file])
      end

      #
      # Renames file to new one.
      #
      # @param [String] name New file name
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Renamed file
      #
      def rename!(name, access = {})
        move!(path, { :name => name }, access)
      end

      #
      # Moves file to given path.
      #
      # @param [String] path
      # @param [Hash] options
      # @option options [String] name
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Copied to file
      #
      def copy!(path, options = {}, access = {})
        options[:name] ||= name
        path = prepare_path("#{path}/#{options[:name]}")

        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Copy' => id }
          request[:path] = "/storage/{{client_id}}/files/#{path}"
        end.execute!

        Storage::File.new(json[:dst_file])
      end

      #
      # Compresses file on server to given archive type.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Archive file
      #
      def compress!(access = {})
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/files/#{id}/archive/zip"
        end.execute!

        # add filename for further file operations
        json[:name] = "#{name}.zip"
        Storage::File.new(json)
      end

      #
      # Deletes file from server.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def delete!(access = {})
        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/storage/{{client_id}}/files/#{guid}"
        end.execute!
      end

      #
      # Moves file to trash on server.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def move_to_trash!(access = {})
        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/storage/{{client_id}}/trash/#{path}/#{name}"
        end.execute!
      end

      #
      # Converts file to GroupDocs::Document.
      #
      # @return [GroupDocs::Document]
      #
      def to_document
        Document.new(:file => self)
      end

    end # File
  end # Storage
end # GroupDocs
