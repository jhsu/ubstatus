require 'sinatra'
require 'net/http'
require 'haml'
require 'backgrounded'

use_in_file_templates!

class Site
  attr_accessor :url, :path, :status, :response_code
  
  backgrounded :check

  def initialize(url, path)
    self.url = url
    self.url = path
  end

  def up?
    r = Net::HTTP.get_response(self.url, self.path)
    self.response_code = r.code.to_i
    if self.response_code >= 200 
      self.status = "OK"
      true
    else
      self.status = "Bork'd"
      false
    end
  end
  
  def to_s
    "#{self.url}"
  end
end

get '/' do
  @sites = []
  [["www.buffalo.edu","/"], 
  ["ublearns.buffalo.edu","/"], 
  ["myub.buffalo.edu","/"], 
  ["helpdesk.buffalo.edu","/Admin/INFO/"]].each do |site|
    begin
      @site = Site.new(site[0],site[1])
      status = @site.up? ? "up" : "down"
    rescue Timeout::Error
      next
    end 
    @sites << @site
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
