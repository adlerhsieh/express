class Category < ActiveRecord::Base
  has_many :posts
  has_many :screencasts
  has_many :trainings
  translates :name
  default_scope {includes(:translations)}
  after_save :translate
  scope :from_posts, -> {
    all.inject([]){|array, c|
      if c.posts.count > 0
        array.push c
      else
        array
      end
    }
  }
  def translate
    Translator.new(self).to_CN
  end
end
