GyacoServer
===========
Gyacoクライアントからのデータアップロードとデータ管理

Dependencies
------------

install ffmpeg

    ## Mac OSX
    % brew install ffmpeg

    ## Ubuntu
    % sudo apt-get install ffmpeg


install rubygems

    % gem install bundler
    % bundle install


Run Server
==========

start development server

    % mkdir server/public
    % ruby server/development.rb

or, use config.ru for Passenger


Run Audio Connect Worker
========================

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
 * format : wav, mp3, amr, mov

file list

 * url : http://example.com/appname/list
 * method : get
 * response : json

delete all files

 * url : http://example.com/appname/all
 * method : delete
 * response : json
 * move files "trash" directory

delete all files(2)

 * url : http://example.com/appname/delete_all
 * method : get
 * response : json
 * move files "trash" directory
