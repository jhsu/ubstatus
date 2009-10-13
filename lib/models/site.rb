class Site < ActiveRecord::Base

  def set_url=(url)
    self.url = url.insert(0, "http://") unless url.match(/^http\:\/\//)
  end

  def check!
    response = Net::HTTP.get_response(URI.parse(self.url))
    self.status = response.code.to_i
    self.save
    return self
  end

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
