class Post < ActiveRecord::Base
  def morphology
    content
  end
end
