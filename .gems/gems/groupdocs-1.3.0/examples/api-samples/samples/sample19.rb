# GET request
get '/sample19' do
  haml :sample19
end

# POST request
post '/sample19' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :sourceFileId, params[:sourceFileId]
  set :targetFileId, params[:targetFileId]
  set :callbackUrl, params[:callbackUrl]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.sourceFileId.empty? or settings.targetFileId.empty?

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})

    source_document = ''
    target_document = ''

    # get source and target documents by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.sourceFileId
        source_document = element
      end
      if element.respond_to?('guid') == true and element.guid == settings.targetFileId
        target_document = element
      end
    end

    unless source_document.instance_of? String and target_document.instance_of? String

      info = source_document.to_document.compare!(target_document.to_document, {:client_id => settings.client_id, :private_key => settings.private_key});
      sleep(5)

      # get job by ID
      job = GroupDocs::Job.new(id: info.id)
      # get all job documents
      documents = job.documents!({:client_id => settings.client_id, :private_key => settings.private_key})
      # get compared file giud
      guid =  documents[:outputs].first.file.guid

      # construct result iframe
      iframe = "<iframe src='https://apps.groupdocs.com/document-viewer/embed/#{guid}' frameborder='0' width='100%' height='600'></iframe>"

    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample19, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :sourceFileId => settings.sourceFileId, :targetFileId => settings.targetFileId, :callbackUrl => settings.callbackUrl, :iframe => iframe, :err => err }
end
