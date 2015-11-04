# GET request
get '/sample16' do
  haml :sample16
end

# POST request
post '/sample16' do
  # set variables
  set :fileId, params[:fileId]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.fileId.empty?

    # construct result iframe
    iframe = "<iframe src='https://apps.groupdocs.com/assembly2/questionnaire-assembly/#{settings.fileId}' frameborder='0' width='100%' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample16, :locals => { :fileId => settings.fileId, :iframe => iframe, :err => err }
end