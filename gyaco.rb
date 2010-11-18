require 'rubygems'
require 'sinatra'

get '/test' do
  'TESTTEST'
end

post '/upload' do
  data = params[:data]
  name = params[:name]
  name = 'data' if name == '' || name.nil?
  File.open("/tmp/#{name}","w"){ |f|
    f.print data
  }
end
