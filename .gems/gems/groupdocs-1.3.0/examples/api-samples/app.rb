require 'sinatra'
require 'groupdocs'
require 'haml'
require 'pp'

get '/' do
  haml :index
end

get '/style.css' do
  sass :style
end

Dir["samples/*.rb"].each {|file| require_relative file }

