# GET request
get '/sample13' do
  haml :sample13
end

# POST request
post '/sample13' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]
  set :email, params[:email]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty? or settings.email.empty?

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
      # add collaborator to doc with annotations
      result = document.to_document.set_collaborators!(settings.email.split(" "), 1, {:client_id => settings.client_id, :private_key => settings.private_key})
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample13, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :fileId => settings.file_id, :email => settings.email, :result => result,  :err => err }
end