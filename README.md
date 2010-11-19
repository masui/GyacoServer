GyacoServer
===========
Gyacoクライアントからのデータアップロードとデータ管理

Dependencies
------------

install ffmpeg

    % sudo port install ffmpeg
    % sudo apt-get install ffmpeg

install rubygems

    % gem install bundler
    % bundle install

see "Gemfile".


Run Server
==========

start development server

    % ruby development.rb

or, use config.ru for Passenger


Run Audio Connect Worker
==========

make connected audio file "audio.mp3" from files directory.

    % ruby worker/audio_connect_worker.rb -help
    % ruby worker/audio_connect_worker.rb -path /path/to/GyacoServer/public/files -out /path/to/GyacoServer/public/audio.mp3 -loop


API
===

upload

 * url : http://example.com/appname/upload
 * method : post (multipart/form-data)
 * post parameter : data, file_ext
 * response : json
 * see "misc/sample_upload_client.rb"

list 

 * url : http://example.com/appname/list
 * method : get
 * response : json
