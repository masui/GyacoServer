#!/usr/bin/env ruby
require 'rubygems'
require 'wav-file'
require 'ArgsParser'
require 'digest/md5'

parser = ArgsParser.parser
parser.bind(:path, :p, 'watch path (required)')
parser.bind(:out, :o, 'out file name (required)')
parser.bind(:loop, :l, 'do loop')
parser.bind(:help, :h, 'show help')
parser.bind(:interval, :i, 'directory watch interval')
first, params = parser.parse(ARGV)

if !parser.has_params([:path, :out]) or parser.has_param(:help)
  puts parser.help
  exit 1
end

params[:path] += '/' unless params[:path] =~ /\/$/
interval = 3
interval = params[:interval] if params[:interval]

tmp_dir = '/tmp/gyaco'
Dir::mkdir(tmp_dir) unless File::exists?(tmp_dir)

files = nil
files_old = nil
loop do
  files = Dir.glob(params[:path]+'*').delete_if{|i| !(i =~ /\.(wav|mp3|amr|mov|3gp|aiff)/i)}.sort.reverse
  if files != files_old and files.size > 0
    sources = Array.new
    files.each{|i|
      out = "#{tmp_dir}/#{i.split(/\//).last.gsub(/\..+/,'.wav')}"
      puts `ffmpeg -i #{i} -ac 1 -ar 44100 #{out}` unless File::exists?(out)
      sources << out if File::exists? out
    }
    p sources

    format = WavFile::readFormat open(sources.first)
    dataChunk = WavFile::readDataChunk open(sources.first)
    md5s = Array.new
    md5s << Digest::MD5.hexdigest(open(sources.first).read)
    if sources.size > 1
      for i in 1...sources.size do
        md5 = Digest::MD5.hexdigest open(sources[i]).read
        next if md5s.include?(md5) # skip same file
        md5s << md5
        data = WavFile::readDataChunk open(sources[i])
        dataChunk.data += data.data
      end
    end
    WavFile::write(open("#{tmp_dir}/tmp.wav", 'w'), format, [dataChunk])
    puts `ffmpeg -y -i #{tmp_dir}/tmp.wav #{params[:out]}`
  end
  files_old = files
  break unless params[:loop]
  sleep interval
end


