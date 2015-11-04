# GET request
get '/sample22' do
  haml :sample22
end

# POST request
post '/sample22' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :fileId, params[:fileId]
  set :email, params[:email]
  set :first_name, params[:first_name]
  set :last_name, params[:last_name]

  begin

    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.fileId.empty? or settings.email.empty? or settings.first_name.empty? or settings.last_name.empty?

    # create new user
    user = GroupDocs::User.new
    user.primary_email = settings.email
    user.nickname = settings.first_name
    user.first_name = settings.first_name
    user.last_name = settings.last_name

    # update account
    GroupDocs::User.update_account!(user, {client_id: settings.client_id, private_key: settings.private_key})

    # create file from GUID
    file = GroupDocs::Storage::File.new(guid: settings.fileId)

    # create document from file
    document = GroupDocs::Document.new(file: file)

    # set new collaboration
    document.set_collaborators!([settings.email], 2, {:client_id => settings.client_id, :private_key => settings.private_key})

    # get all collaborations
    collaborations = document.collaborators!({:client_id => settings.client_id, :private_key => settings.private_key})

    # set document reviewers
    document.set_reviewers!(collaborations, {:client_id => settings.client_id, :private_key => settings.private_key})

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample22, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :fileId => settings.fileId, :email => settings.email, :first_name => settings.first_name, :last_name => settings.last_name }
end
