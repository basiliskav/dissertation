# GET request
get '/sample4' do
  haml :sample4
end

# POST request
post '/sample4' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:file_id]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    dowload_file = ''

    # get file by file ID
    files_list.each do |element|
      if element.id == Integer(settings.file_id)
        dowload_file = element
      end
    end

    # download file
    dowloaded_file = dowload_file.download!(File.dirname(__FILE__), { :client_id => settings.client_id, :private_key => settings.private_key})
    unless dowloaded_file.empty?
      massage = "<font color='green'>File was downloaded to the <font color='blue'>#{dowloaded_file}</font> folder</font> <br />"
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample4, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :file_id => settings.file_id, :massage => massage, :err => err }
end
