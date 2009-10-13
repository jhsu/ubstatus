require 'sinatra/activerecord/rake'
require 'main'

Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

task :env do
  $:.unshift '.'
# require 'main'
end

namespace :dev do 
  task :seed => [:env] do
    [ "www.buffalo.edu", 
      "ublearns.buffalo.edu", 
      "myub.buffalo.edu", 
      "helpdesk.buffalo.edu/Admin/INFO/"].each do |www|
      s = Site.new
      s.set_url = www
      s.status = 200
      s.save
    end
  end
end
