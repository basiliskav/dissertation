# GET request
get '/sample17' do
  haml :sample17
end

# POST request
post '/sample17' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file, params[:file]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file.nil?

    # construct path
    filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    # open file
    File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    # upload file
    file = GroupDocs::Storage::File.upload!(filepath, {}, client_id: settings.client_id, private_key: settings.private_key)
    # compress file
    file.compress!({client_id: settings.client_id, private_key: settings.private_key})

    # construct result messages
    massage = "<p>Archive created and saved successfully. Here you can see your <strong>#{params[:file][:filename]}</strong> file in the GroupDocs Embedded Viewer.</p>"
    iframe = "<iframe src='https://apps.groupdocs.com/document-viewer/Embed/#{file.guid}' frameborder='0' width='720' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample17, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :iframe=>iframe, :massage => massage, :err => err }
end
