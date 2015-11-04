# GET request
get '/sample3' do
  haml :sample3
end

# POST request
post '/sample3' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?

    # construct path
    filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    # open file
    File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    # make a request to API using client_id and private_key
    file = GroupDocs::Storage::File.upload!(filepath, {}, client_id: settings.client_id, private_key: settings.private_key)

    # result massages
    massage = "<p>File was uploaded to GroupDocs. Here you can see your <strong>#{params[:file][:filename]}</strong> file in the GroupDocs Embedded Viewer.</p>"
    iframe = "<iframe src='https://apps.groupdocs.com/document-viewer/Embed/#{file.guid}' frameborder='0' width='720' height='600'></iframe>"
  
  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample3, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :iframe=>iframe, :massage => massage, :err => err }
end
