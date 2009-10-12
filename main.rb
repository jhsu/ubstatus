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
  @sites.each do |site|
    site = Site.new(site)
    site.up?
    @sites << site
  end
  haml :index
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
  - @sites.each do |s|
    %li= "#{@site.to_s} &rarr;  #{@site.status}"
