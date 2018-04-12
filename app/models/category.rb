class Category < ActiveRecord::Base

  include DefaultSetter

  has_many :posts
  has_many :screencasts
  has_many :trainings

  scope :from_posts, -> {
    all.inject([]){|array, c|
      if c.posts.count > 0
        array.push c
      else
        array
      end
    }
  }

end
