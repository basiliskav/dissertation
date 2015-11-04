# GET request
get '/sample12' do
  haml :sample12
end

# POST request
post '/sample12' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    document = ''

    # get document by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.file_id
        document = element
      end
    end

    unless document.instance_of? String
      # get list of annotations
      annotations = document.to_document.annotations!(:client_id => settings.client_id, :private_key => settings.private_key)
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample12, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :annotations => annotations, :fileId => settings.file_id, :err => err }
end
