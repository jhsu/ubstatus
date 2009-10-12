require 'sinatra'
require 'sinatra/activerecord'
require 'net/http'
require 'haml'
require 'lib/models/site.rb'

set :database, 'sqlite://ubstatus.db'

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
    %li= "#{@site} &rarr;  #{@site.status}"
