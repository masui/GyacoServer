require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'rack'
require File.dirname(__FILE__)+'/main'

set :environment, :development

set :port, 8090
set :server, 'thin'

Sinatra::Application.run
