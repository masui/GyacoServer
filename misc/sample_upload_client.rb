#!/usr/bin/env ruby
require 'rubygems'
require File.dirname(__FILE__)+'/lib/upload_client'

if ARGV.size < 1
  puts 'ruby sample_upload_client.rb test.wav'
  exit 1
end

begin
  url = UploadClient::upload(ARGV.first, 'http://localhost:8090/upload')
  puts url
rescue => e
  STDERR.puts e
  next
end
