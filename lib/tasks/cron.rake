require 'main'

task :cron do
  Site.all.each do |s|
    puts "checking #{s.url}"
    s.check!
  end
end
