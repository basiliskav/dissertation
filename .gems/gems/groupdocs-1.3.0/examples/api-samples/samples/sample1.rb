# GET request
get '/sample1' do
  haml :sample1
end

# POST request
post '/sample1' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?

    # make a request to API using client_id and private_key
    user = GroupDocs::User.get!({:client_id => settings.client_id, :private_key => settings.private_key})

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample1, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :user => user, :err => err }
end
