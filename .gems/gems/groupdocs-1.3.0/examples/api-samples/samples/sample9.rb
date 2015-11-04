# GET request
get '/sample9' do
  haml :sample9
end

# POST request
post '/sample9' do
  # set variables
  set :guid, params[:guid]
  set :width, params[:width]
  set :height, params[:height]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.guid.empty? or settings.width.empty? or settings.height.empty?

    # construct result string
    v_url = "https://apps.groupdocs.com/document-viewer/embed/#{settings.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      
    if v_url
      v_url = v_url
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample9, :locals => { :guid => settings.guid, :width => settings.width, :height => settings.height, :v_url=>v_url, :err => err }
end
