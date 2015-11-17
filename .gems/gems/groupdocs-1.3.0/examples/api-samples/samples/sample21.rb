# GET request
get '/sample21' do
  haml :sample21
end

# POST request
post '/sample21' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :email, params[:email]
  set :name, params[:name]
  set :lastName, params[:lastName]
  set :file, params[:file]

  begin

    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.email.empty? or settings.name.empty? or settings.lastName.empty? or settings.file.nil?

    # construct path
    filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    # open file
    File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    # upload file
    file = GroupDocs::Storage::File.upload!(filepath, {}, client_id: settings.client_id, private_key: settings.private_key)

    # create envelope using user id and entered by user name
    envelope = GroupDocs::Signature::Envelope.new
    envelope.name = params[:file][:filename]
    envelope.email_subject = "Sing this!"
    envelope.create!({}, client_id: settings.client_id, private_key: settings.private_key)

    # Add uploaded document to envelope
    envelope.add_document!(file.to_document, {}, {client_id: settings.client_id, private_key: settings.private_key})

    # Get role list for current user
    roles = GroupDocs::Signature::Role.get!({}, {client_id: settings.client_id, private_key: settings.private_key})

    # Create new recipient
    recipient = GroupDocs::Signature::Recipient.new
    recipient.email = settings.email
    recipient.first_name = settings.name
    recipient.last_name = settings.lastName
    recipient.role_id = roles.detect { |role| role.name == "Signer" }.id

    # Add recipient to envelope
    add = envelope.add_recipient!(recipient, {client_id: settings.client_id, private_key: settings.private_key})

    # get recipient id
    recipient_id = add[:recipient][:id]

    # Send envelop
    envelope.send!(nil, {client_id: settings.client_id, private_key: settings.private_key})

    # Make iframe
    iframe = "<iframe src='https://apps.groupdocs.com/signature/signembed/#{envelope.id}/#{recipient_id}' frameborder='0' width='720' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample21, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :email => settings.email, :name => settings.name, :lastName => settings.lastName, :iframe => iframe, :err => err }
end
