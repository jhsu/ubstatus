require 'sinatra'
require 'net/http'
require 'haml'
require 'backgrounded'

use_in_file_templates!

class Site
  attr_accessor :url, :status, :response_code
  
  backgrounded :check

  def initialize(url)
    self.url = url.insert(0, "http://") unless url.match(/^http\:\/\//)
  end

  def up?
    r = Net::HTTP.get_response(URI.parse(self.url))
    self.response_code = r.code
    if self.response_code =~ /2|3\d{2}/
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
  [["www.buffalo.edu"], 
  ["ublearns.buffalo.edu"], 
  ["myub.buffalo.edu"], 
  ["helpdesk.buffalo.edu/Admin/INFO/"]].each do |site|
    begin
      @site = Site.new(site)
      @site.up?
      @sites << @site
    rescue Timeout::Error
      next
    end 
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
