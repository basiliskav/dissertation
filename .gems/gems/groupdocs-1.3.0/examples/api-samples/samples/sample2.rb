# GET request
get '/sample2' do
  haml :sample2
end

# POST request
post '/sample2' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key })

    # construct list of files
    filelist = ''
    files_list.each {|element| filelist << "#{element.name}<br />"}

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample2, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :filelist => filelist, :err => err }
end
