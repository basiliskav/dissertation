# GET request
get '/sample7' do
  haml :sample7
end

# POST request
post '/sample7' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
   
  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {:extended => true}, { :client_id => settings.client_id, :private_key => settings.private_key})

    # construct result string
    thumbnails = ''
    files_list.each do |element|
      if element.class.name.split('::').last == 'Folder'
        next
      end
      
      if element.thumbnail
        name = element.name 
        thumbnails += "<p><img src='data:image/png;base64,#{element.thumbnail}', width='40px', height='40px'> #{name}</p>"
      end
    end
    
    unless thumbnails.empty?
      set :thumbnails, thumbnails
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample7, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :thumbnailList => thumbnails, :err => err }
end
