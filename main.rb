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
  set :views, File.dirname(__FILE__) + '/lib/views'
end

use_in_file_templates!

helpers do
  def stylesheets(styles, media="screen")
    html = ""
    styles.each do |style|
      tag = Haml::Engine.new("%link{:href => '/#{style}.css',  :media => '#{media}', :rel => 'stylesheet'}")
      html << tag.render
    end
    html
  end
end

get '/stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :stylesheet
end

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
    if User.find_by_api_key(params[:api_key], :limit => 1) && @site = Site.first(:conditions => "url like '%#{params[:url]}%'")
      @site.status = params[:status].to_i
      @site.save
    else
      error 404
    end
  end
  redirect '/'    
end


__END__

@@ layout
%html
  %head
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'}/

    = stylesheets ['stylesheet']

    %title UB Apps Status Dashboard
  %body
    #container
      %h1 UB Apps Status Dashboard
      = yield


@@ index
%dl
  - sites.each do |s|
    %dt
      %a{ :href => s.url }= s
    %dd= s.status




