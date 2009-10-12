class Site < ActiveRecord::Base

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
