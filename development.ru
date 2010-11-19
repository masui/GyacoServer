require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'rack'
require 'main'

set :environment, :development

set :port, 8090
set :server, 'thin'

Sinatra::Application.run
