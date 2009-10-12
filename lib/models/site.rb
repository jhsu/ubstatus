class Site < ActiveRecord::Base

# def url=(www)
#   self.url = www.insert(0, "http://") unless www.match(/^http\:\/\//)
# end

  def up?
    if status =~ /2|3\d{2}/
      true
    else
      false
    end
  end

  def to_s
    url
  end
end
