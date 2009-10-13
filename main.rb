require 'sinatra'
require 'sinatra/activerecord'
require 'net/http'
require 'haml'
require 'lib/models/site.rb'
require 'lib/models/user.rb'

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

post '/update_all' do
  if params[:api_key]
    redirect '/' unless User.find(:first, :conditions => {:api_key => params[:api_key]})
    @sites = Site.all
    @sites.each {|s| s.check! }
    haml :index, :locals => {:sites => @sites }
  else 
    redirect '/'    
  end
end

post '/update/:url' do
  if params[:api_key] && params[:status]
    if @site = Site.find(:first, :conditions => "url like '%#{params[:url]}%'")
      @site.status = params[:status].to_i
      @site.save
    else
      @site = Site.new
      @site.set_url = params[:url]
      @site.status = 200
      @site.save
    end
  end
  redirect '/'    
end


__END__

@@ layout
%html
  %head
    %title
  %body
    #container
      %h1 UB Apps Status Dashboard
      = yield


@@ index
%ul
  - sites.each do |s|
    %li= "#{s} &rarr; #{s.status}"
