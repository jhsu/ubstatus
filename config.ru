require 'rubygems'
gem 'sinatra', '~> 0.9.4'
require 'main'

set :run, false
set :environment, :production
run Sinatra::Application
