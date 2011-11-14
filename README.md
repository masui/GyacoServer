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

 * url : http://example.com/gyaco/upload
 * method : post (multipart/form-data)
 * post parameter : data, file_ext
 * response : json
 * see "misc/sample_upload_client.rb"
 * format : wav, mp3, amr, mov

file list

 * url : http://example.com/gyaco/list
 * method : get
 * response : json

delete file

 * url : http://example.com/gyaco/delete
 * post parameter : "name=foo.mp3"
 * method : delete
 * response : json
 * move file "trash" directory
 * % curl -d 'name=foo.mp3' 'http://example.com/gyaco/delete' --request DELETE

delete all files

 * url : http://example.com/gyaco/all
 * method : delete
 * response : json
 * move files "trash" directory
 * % curl 'http://example.com/gyaco/all' --request DELETE
