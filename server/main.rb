require 'rubygems'
require 'sinatra'
require 'rack'
require 'sinatra/reloader' if development?
require 'json'

@@dbdir = 'files'
@@dbpath = File.dirname(__FILE__)+'/public/'+@@dbdir
@@trash_path = File.dirname(__FILE__)+'/trash/'

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
  name = "#{@@dbpath}/#{Time.now.to_i}_#{Time.now.usec}"
  name += ".#{ext}" if ext
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

get '/list' do
  files = Dir.glob("#{@@dbpath}/*").delete_if{|i|
    i =~ /^\.+$/
  }
  file_time = Hash.new
  files.each{|i|
    file_time["#{app_root}/#{@@dbdir}/#{i.split(/\//).last}"] = File::mtime(i).to_i
  }
  @mes = {
    :size => files.count,
    :files => file_time
  }.to_json
end

def delete_files
  count = 0
  Dir.mkdir @@trash_path unless File::exists? @@trash_path
  Dir.glob("#{@@dbpath}/*").delete_if{|i|
    i =~ /^\.+$/
  }.each{|i|
    begin
      File::rename(i, @@trash_path+i.split(/\//).last)
      count += 1
    rescue => e
      STDERR.puts e
    end
  }
  @mes = {
    :message => "deleted #{count} files"
  }.to_json
end

delete '/all' do
  delete_files
end

get '/delete_all' do
  delete_files
end


