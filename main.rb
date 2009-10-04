require 'sinatra'
require 'net/http'
require 'haml'

use_in_file_templates!

get '/' do
  @sites = []
  [["www.buffalo.edu","/"], 
  ["ublearns.buffalo.edu","/"], 
  ["myub.buffalo.edu","/"], 
  ["helpdesk.buffalo.edu","/Admin/INFO/"]].each do |site|
    begin
      r = Net::HTTP.get_response(site[0], site[1])
    rescue Timeout::Error
      next
    end 
    status = r.code.to_i  >= 200 && r.code.to_i <400
    @sites << { :site => site[0], :status => status }
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
    %li= "#{s[:site]} &rarr;  #{s[:status]}"
