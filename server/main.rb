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
<<EOF
<form method="post" action="#{app_root}/upload" enctype="multipart/form-data">
  file : <input type="file" name="file"><br>
  comment : <input type="text" name="comment" size="40"><br>
  <input type="submit" name="upload" value="upload!!">
</form>
EOF
end

post '/upload' do
  if !params[:file]
    @mes = {:error => 'error'}.to_json
  else
    name = "#{@@dbpath}/#{Time.now.to_i}_#{Time.now.usec}"+File.extname(params[:file][:filename])
    File.open(name, 'wb'){|f|
      f.write params[:file][:tempfile].read
    }
    if File::exists? name
      @mes = {
        :url => "#{app_root}/#{@@dbdir}/#{name.split(/\//).last}",
        :size => File.size(name)
      }.to_json    
    end
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
  FileUtils::cp(File.dirname(__FILE__)+'/public/empty.mp3', File.dirname(__FILE__)+'/public/audio.mp3')
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


