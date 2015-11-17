unless RUBY_VERSION.to_f < 1.9
  require 'simplecov'
  SimpleCov.configure do
    add_filter('spec/')
    add_filter('vendor/')
  end
  SimpleCov.start
end

require 'webmock/rspec'
require 'groupdocs'

# shared examples
Dir['spec/support/shared_examples/**/*.rb'].each { |file| file = file.sub(/spec\//, ''); require file }

# matchers extension
RSpec::Matchers.define :have_accessor do |name|
  match do |object|
    object.should respond_to(:"#{name}")
    object.should respond_to(:"#{name}=")
  end
end
RSpec::Matchers.define :have_alias do |aliased, original|
  match do |object|
    object.should respond_to(aliased)
    object.method(aliased).should == object.method(original)
  end
end
RSpec::Matchers.define :alias_accessor do |aliased, original|
  match do |object|
    object.should have_alias(:"#{aliased}",  :"#{original}")
    object.should have_alias(:"#{aliased}=",  :"#{original}=")
  end
end

# configure API access
RSpec.configure do |spec|
  spec.before(:all) do
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id   = '07aaaf95f8eb33a4'
      groupdocs.private_key = '5cb711b3a52ffc5d90ee8a0f79206f5a'
      groupdocs.api_version = '2.0'
    end
  end
end


#
# Mocks JSON response.
#
def mock_response(json)
  subject.response = json
end

#
# Mocks API server.
#
def mock_api_server(json, headers = {})
  request = stub_request(:any, /#{GroupDocs.api_server}.*/)
  request = request.with(:headers => headers) unless headers.empty?
  request.to_return(:body => json)
end

#
# Loads JSON file.
#
def load_json(name)
  File.read("spec/support/json/#{name}.json")
end
