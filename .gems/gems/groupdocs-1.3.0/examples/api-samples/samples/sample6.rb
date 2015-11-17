# GET request
get '/sample6' do
  haml :sample6
end

# POST request
post '/sample6' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
   
  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?

    # construct file path and open file
	  file_one_path = "#{Dir.tmpdir}/#{params[:document][:filename]}"
    File.open(file_one_path, 'wb') { |f| f.write(params[:document][:tempfile].read) }

    # create new file
	  file_one = GroupDocs::Storage::File.new(name: params[:document][:filename], local_path: file_one_path)
    document_one = file_one.to_document

    # construct signature path and open file
	  signature_one_path = "#{Dir.tmpdir}/#{params[:signature][:filename]}"
    File.open(signature_one_path, 'wb') { |f| f.write(params[:signature][:tempfile].read) }

    # add signature to file using API
    signature_one = GroupDocs::Signature.new(name: 'Test', image_path: signature_one_path)
    signature_one.position = { top: 0.1, left: 0.07, width: 50, height: 50}

    # make a request to API using client_id and private_key
    signed_documents = GroupDocs::Document.sign_documents!([document_one], [signature_one], {}, { :client_id => settings.client_id, :private_key => settings.private_key })
    guid = signed_documents.first.file.guid

    # generate result
    if signed_documents
      iframe = "<iframe src='https://apps.groupdocs.com/document-viewer/Embed/#{guid}' frameborder='0' width='720' height='600'></iframe>"
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample6, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe, :err => err }
end