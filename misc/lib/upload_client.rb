#!/usr/bin/env ruby
require 'rubygems'
require 'uri'
require 'json'
require 'httpclient'

class UploadError < Exception
end

module UploadClient
  
  def self.upload(filename, url)
    c = HTTPClient.new
    res = nil

    open(filename){|file|
      postdata = {
        'file' => file
      }
      res = c.post_content(url, postdata)
    }

    begin
      res = JSON.parse(res)
      raise UploadError.new res['error'] if res['error']
      raise UploadError.new 'file size error' if res['size'].to_i != File.size(filename)
      return res['url'] if res['url']
    rescue => e
      throw e
    end
    raise UploadError.new 'unknown error'

  end

end
