# GET request
get '/envelope-sample' do
  haml :envelope_sample
end

# POST request to handle callback when document was signed
post '/envelope-sample/sign' do
  # Content Type of callback is application/json
  data = JSON.parse(request.body.read)
  begin
    raise "Empty params!" if data.empty?
    #create empty file and write data as "key: value" to it
    outFile = File.new("signed", "w")
    data.each do |key, value|
      outFile.write("#{key}: #{value} \n")
    end
    outFile.close
  rescue Exception => e
    err = e.message
  end
end


# POST request to handle callback and download envelop when document was signed
post '/envelope-sample/sign-and-download' do
  data = JSON.parse(request.body.read)
  begin  
    raise "Empty params!" if data.empty?
    GroupDocs.configure do |groupdocs|
        groupdocs.client_id = '' # Your client Client ID here
        groupdocs.private_key = '' # Your API Key here
        groupdocs.api_server = 'https://api.groupdocs.com'
    end
    data.each do |key, value|
      if key == 'SourceId'
        # Create envelop with id and name as SourceId parameter from callback
        envelope = GroupDocs::Signature::Envelope.new id: value,
                                                    name: value
        # download signed documents as archive
        envelope.signed_documents! '.'
      end
    end
  rescue Exception => e
    err = e.message
  end
end

# GET request to check if envelop was signed
get '/envelope-sample/check' do
  if File.exist?('signed')
    File.readlines('signed').each do |line|
    end
  else 
    'Have not signed yet'
  end
end

# POST request
post '/envelope-sample' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]

  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?

    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = params[:client_id]
      groupdocs.private_key = params[:private_key]
      groupdocs.api_server = 'https://stage-api.groupdocs.com'
    end
     
    # upload document
    filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    file = GroupDocs::Storage::File.upload!(filepath, {}, client_id: settings.client_id, private_key: settings.private_key)
    document = file.to_document
     
    # create envelope
    envelope = GroupDocs::Signature::Envelope.new
    envelope.name = "Envelope"
    envelope.email_subject = "Sing this!"
    envelope.create!
     
    # add document to envelope
    envelope.add_document! document
     
    # update document object after it's created
    document = envelope.documents!.first
     
    # add new recipient to envelope
    roles = GroupDocs::Signature::Role.get!
    recipient = GroupDocs::Signature::Recipient.new
    recipient.email = 'john@smith.com'
    recipient.first_name = 'John'
    recipient.last_name = 'Smith'
    recipient.role_id = roles.detect { |role| role.name == "Signer" }.id
    envelope.add_recipient! recipient
     
    # update recipient object after it's created
    recipient = envelope.recipients!.first

    #
    # You can add fields manually.
    #

    # add city field to envelope
    #field = GroupDocs::Signature::Field.get!.detect { |f| f.type == :single_line }
    #field.name = 'City'
    #field.location = { location_x: 0.3, location_y: 0.2, page: 1 }
    #envelope.add_field! field, document, recipient
     
    # add signature field to envelope
    #field = GroupDocs::Signature::Field.get!.detect { |f| f.type == :signature }
    #field.location = { location_x: 0.3, location_y: 0.3, page: 1 }
    #envelope.add_field! field, document, recipient

    # URL for callback
    webhook = 'http://groupdocs-ruby-samples.herokuapp.com/envelope-sample/sign'

    # send envelope
    envelope.send! webhook
     
    # construct embedded signature url
    url = "https://stage-apps.groupdocs.com/signature/signembed/#{envelope.id}/#{recipient.id}"
    iframe = "<iframe src='#{url}' frameborder='0' width='720' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  haml :envelope_sample, :locals => { :client_id => settings.client_id, :private_key => settings.private_key, :err => err, :iframe =>  iframe}
end
