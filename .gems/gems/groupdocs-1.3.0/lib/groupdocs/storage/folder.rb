module GroupDocs
  module Storage
    class Folder < Api::Entity

      include Api::Helpers::AccessMode
      include Api::Helpers::Path

      #
      # Creates folder on server.
      #
      # @param [String] path Path of folder to create starting with "/"
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::Folder] Created folder
      #
      def self.create!(path, access = {})
        path = prepare_path(path)

        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/paths/#{path}"
        end.execute!

        Storage::Folder.new(json)
      end

      #
      # Returns a list of all directories and files in the path.
      #
      # @param [String] path Path of directory to list starting from root ('/')
      # @param [Hash] options Hash of options
      # @option options [Integer] :page Page to start with
      # @option options [Integer] :count How many items to list
      # @option options [String] :order_by Field name to sort by
      # @option options [Boolean] :order_asc Set to true to return in ascending order
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Storage::Folder, GroupDocs::Storage::File>]
      #
      def self.list!(path = '', options = {}, access = {})
        path = prepare_path(path)
        new(:path => path).list!(options, access)
      end

      # @attr [Integer] id
      attr_accessor :id
      # @attr [Integer] size
      attr_accessor :size
      # @attr [Integer] folder_count
      attr_accessor :folder_count
      # @attr [Integer] file_count
      attr_accessor :file_count
      # @attr [Time] created_on
      attr_accessor :created_on
      # @attr [Time] modified_on
      attr_accessor :modified_on
      # @attr [String] url
      attr_accessor :url
      # @attr [String] name
      attr_accessor :name
      # @attr [String] path
      attr_accessor :path
      # @attr [Integer] version
      attr_accessor :version
      # @attr [Integer] type
      attr_accessor :type
      # @attr [Symbol] access
      attr_accessor :access

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def created_on
        Time.at(@created_on / 1000)
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
      # Converts access mode to human-readable format.
      #
      # @return [Symbol]
      #
      def access
        parse_access_mode(@access)
      end

      #
      # Returns an array of files and folders.
      #
      # @param [Hash] options Hash of options
      # @option options [Integer] :page Page to start with
      # @option options [Integer] :count How many items to list
      # @option options [String] :order_by Field name to sort by
      # @option options [Boolean] :order_asc Set to true to return in ascending order
      # @option options [String] :filter Filter by name
      # @option options [Array<Symbol>] :file_types Array of file types to return
      # @option options [Boolean] :extended Set to true to return extended information
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Storage::Folder, GroupDocs::Storage::File>]
      #
      def list!(options = {}, access = {})
        if options[:order_by]
          options[:order_by] = options[:order_by].camelize
        end

        full_path = prepare_path("#{path}/#{name}")

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/storage/{{client_id}}/folders/#{full_path}"
        end
        api.add_params(options)
        json = api.execute!

        folders = json[:folders].map do |folder|
          folder.merge!(:path => full_path)
          Storage::Folder.new(folder)
        end
        files = json[:files].map do |file|
          file.merge!(:path => full_path)
          Storage::File.new(file)
        end

        folders + files
      end

      #
      # Moves folder contents to given path.
      #
      # @param [String] destination Destination to move contents to
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] Moved to folder path
      #
      def move!(destination, access = {})
        src_path = prepare_path(path)
        dst_path = prepare_path("#{destination}/#{name}")

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Move' => src_path }
          request[:path] = "/storage/{{client_id}}/folders/#{dst_path}"
        end.execute!

        dst_path
      end

      #
      # Copies folder contents to given path.
      #
      # @param [String] destination_path Destination to copy contents to
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] Copied to folder path
      #
      def copy!(destination, access = {})
        src_path = prepare_path(path)
        dst_path = prepare_path("#{destination}/#{name}")

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Copy' => src_path }
          request[:path] = "/storage/{{client_id}}/folders/#{dst_path}"
        end.execute!

        dst_path
      end

      #
      # Creates folder on server.
      #
      # Note that it doesn't update self and instead returns new instance.
      #
      # @example
      #   folder = GroupDocs::Storage::Folder.new(name: 'Folder')
      #   folder = folder.create!
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::Folder] Created folder
      #
      def create!(access = {})
        self.class.create! prepare_path("#{path}/#{name}"), access
      end

      #
      # Deletes folder from server.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def delete!(access = {})
        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/storage/{{client_id}}/folders/#{prepare_path("#{path}/#{name}")}"
        end.execute!
      end

      #
      # Returns an array of users a folder is shared with.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::User>]
      #
      def sharers!(access = {})
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
        end.execute!

        json[:shared_users].map do |user|
          User.new(user)
        end
      end

      #
      # Sets folder sharers to given emails.
      #
      # If empty array or nil passed, clears sharers.
      #
      # @param [Array] emails List of email addresses to share with
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::User>]
      #
      def sharers_set!(emails, access = {})
        if emails.nil? || emails.empty?
          sharers_clear!(access)
        else
          json = Api::Request.new do |request|
            request[:access] = access
            request[:method] = :PUT
            request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
            request[:request_body] = emails
          end.execute!

          json[:shared_users].map do |user|
            User.new(user)
          end
        end
      end

      #
      # Clears sharers list.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return nil
      #
      def sharers_clear!(access = {})
        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
        end.execute![:shared_users]
      end

    end # Folder
  end # Storage
end # GroupDocs
