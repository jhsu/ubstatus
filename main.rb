require 'sinatra'
require 'sinatra/activerecord'
require 'net/http'
require 'haml'
require 'lib/models/site.rb'

configure do 
  if (ENV['DATABASE_URL'])
    set :database, ENV['DATABASE_URL']
  else
    set :database, "sqlite://ubstatus.db" 
  end
end

use_in_file_templates!

get '/' do
  @sites = Site.all
  haml :index, :locals => {:sites => @sites }
end


__END__

@@ layout
%html
  %head
    %title
  %body
    = yield


@@ index
%ul
  - sites.each do |s|
    %li= "#{s} &rarr; #{s.status}"
