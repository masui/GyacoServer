#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'uri'
require 'open-uri'
require 'json'

class UploadError < Exception
end

module UploadClient
  
  def self.upload(filename, url)
    open(filename, 'rb'){|f|
      bin = f.read
      boundary = '----UPLOADER_BOUNDARY----'
      file_ext = ''
      file_ext = filename.split(/\./).last if filename =~ /\..+/
      data = <<EOF
--#{boundary}\r
content-disposition: form-data; name="file_ext"\r
\r
#{file_ext}\r
--#{boundary}\r
content-disposition: form-data; name="data"\r
\r
#{bin}\r
--#{boundary}--\r
EOF
  
      header = {
        'Content-Length' => data.size.to_s,
        'Content-type' => "multipart/form-data; boundary=#{boundary}"
      }
      
      uploader = URI.parse url
      Net::HTTP.start(uploader.host, uploader.port){|http|
        response = http.post(uploader.path, data, header)
        begin
          res = JSON.parse(response.body)
          raise UploadError.new res['error'] if res['error']
          raise UploadError.new 'file size error' if res['size'].to_i != bin.size
          return res['url'] if res['url']
        rescue => e
          throw e
        end
      }
      raise UploadError.new 'unknown error'
    }
  end
end
