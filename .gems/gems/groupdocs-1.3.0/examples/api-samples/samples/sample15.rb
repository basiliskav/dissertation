# GET request
get '/sample15' do
  haml :sample15
end

# POST request
post '/sample15' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?

    # check the number of document's views. Make a request to API using client_id and private_key
    views = GroupDocs::Document.views!({}, { :client_id => settings.client_id, :private_key => settings.private_key})
    total = views.count()

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample15, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :total => total, :err => err }
end