# GET request
get '/annotation-sample' do
  haml :annotation_sample
end

# POST request
post '/annotation-sample' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_name, params[:file_name]

  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_name.empty?

    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = params[:client_id]
      groupdocs.private_key = params[:private_key]
      groupdocs.api_server = 'https://api.groupdocs.com'
    end
    # get document metadata
    metadata = GroupDocs::Document.metadata!('resume.pdf')
    document = GroupDocs::Storage::File.new(id: metadata.id, guid: metadata.guid).to_document
     
    # create new user
    user = GroupDocs::User.new
    user.nickname = 'test_account'
    user.primary_email = 'test_email@email.com'
    user.first_name = 'First name'
    user.last_name = 'Last name'
    user = GroupDocs::User.update_account!(user)
     
    # add collaborator
    document.add_collaborator! user unless document.collaborators!.any? { |c| c.guid == user.guid }
     
    # build url
    annotation = true # looks like "IsAnnotation" is some helper method so I stub it here
    url = if annotation
    "/document-annotation2/embed?quality=50&guid=#{document.file.guid}&uid=#{user.guid}&download=True"
    else
    "/document-viewer/embed?quality=50&guid=#{document.file.guid}&uid=#{user.guid}&download=True"
    end

    url = GroupDocs::Api::Request.new(path: url).prepare_and_sign_url
    iframe_url = "https://apps.groupdocs.com#{url}"
  rescue Exception => e
    err = e.message
  end

  haml :annotation_sample, :locals => { :client_id => settings.client_id, :private_key => settings.private_key, :err => err, :file_name => settings.file_name, :iframe_url => iframe_url}
end
