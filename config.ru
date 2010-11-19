require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'rack'
require 'main'

set :environemt, :production

run Sinatra::Application
