require 'main'

task :cron do
  Site.all.each do |s|
    s.check!
  end
end
