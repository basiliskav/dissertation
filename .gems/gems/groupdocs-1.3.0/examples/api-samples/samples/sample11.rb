# GET request
get '/sample11' do
  haml :sample11
end

# POST request
post '/sample11' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]
  set :annotation_type, params[:annotation_type]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty? or settings.annotation_type.empty?

    # annotation types
    types = {'text' => 0, 'area' => 1, 'point' => 2}

    # required parameters
    allParams = allParams = ['annotation_type', 'box_x', 'box_y', 'text']

    # added required parameters depends on  annotation type ['text' or 'area']
    if settings.annotation_type == "text"
      allParams = allParams | ['box_width', 'box_height', 'annotationPosition_x', 'annotationPosition_y']
    elsif settings.annotation_type == "area"
      allParams = allParams | ['box_width', 'box_height']
    end

    # checking required parameters
    allParams.each do |param|
      raise "Please enter all required parameters" if params[param].empty?
    end

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    document = ''

    # get document by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.file_id
        document = element
      end
    end

    unless document.instance_of? String

      # start create new annotation
      annotation = GroupDocs::Document::Annotation.new(document: document.to_document)
      annotation.type = types[settings.annotation_type]

      # construct requestBody depends on annotation type
      # text annotation
      if settings.annotation_type == "text"
        annotation.box = {x: params['box_x'], y: params['box_y'], width: params['box_width'], height: params['box_height']}
        annotation.annotationPosition = {x: params['annotationPosition_x'], y: params['annotationPosition_y']}

      # area annotation
      elsif settings.annotation_type == "area"
        annotation.box = {x: params['box_x'], y: params['box_y'], width: params['box_width'], height: params['box_height']}
        annotation.annotationPosition = {x: 0, y: 0}

      # point annotation
      elsif settings.annotation_type == "point"
        annotation.box = {x: params['box_x'], y: params['box_y'], width: 0, height: 0}
        annotation.annotationPosition = {x: 0, y: 0}
      end

      # call create method
      annotation.create!({ :client_id => settings.client_id, :private_key => settings.private_key})

      # add annotation reply
      reply = GroupDocs::Document::Annotation::Reply.new(annotation: annotation)
      reply.text = params['text']
      reply.create!({ :client_id => settings.client_id, :private_key => settings.private_key})

    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample11, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :fileId => settings.file_id, :annotationType => settings.annotation_type, :annotationId => (defined? annotation.id) ? annotation.id : nil, :annotationText => params['text'], :err => err }
end