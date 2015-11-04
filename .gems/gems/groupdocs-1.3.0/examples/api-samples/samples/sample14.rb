# GET request
get '/sample14' do
  haml :sample14
end

# POST request
post '/sample14' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :folder, params[:folder]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.folder.empty?

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!(settings.folder, {}, { :client_id => settings.client_id, :private_key => settings.private_key})

    # get list of shares for a folder
    shares =  files_list.first.sharers!({:client_id => settings.client_id, :private_key => settings.private_key})

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample14, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :folder => settings.folder, :shares => shares, :err => err }
end