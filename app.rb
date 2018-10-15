require 'rubygems'
require 'sinatra'

get '/' do
  erb :main
end

get '/new' do
  erb :new
end
