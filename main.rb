require 'rubygems'
require 'sinatra'
require 'rack'
require 'sinatra/reloader' if development?
require 'json'

@@dbdir = 'files'
@@dbpath = File.dirname(__FILE__)+'/public/'+@@dbdir

Dir::mkdir(@@dbpath) unless File::exist?(@@dbpath)

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

get '/' do
  @mes = 'gyaco server'
end

post '/upload' do
  data = params[:data]
  ext = params[:file_ext]
  name = "#{@@dbpath}/#{Time.now.to_i}_#{Time.now.usec}.#{ext}"
  File.open(name, 'w'){ |f|
    f.write data
  }
  if File::exists? name
    @mes = {
      :url => "#{app_root}/#{@@dbdir}/#{name.split(/\//).last}",
      :size => data.size
    }.to_json
  end
end
