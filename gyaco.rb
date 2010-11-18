require 'rubygems'
require 'sinatra'

#
# http://masui.sfc.keio.ac.jp/gyaco/upload にPOST
# namd=
# data=
#
post '/upload' do
  data = params[:data]
  name = params[:name]
  name = 'data' if name == '' || name.nil?
  File.open("db/#{name}","w"){ |f|
    f.print data
  }
end
