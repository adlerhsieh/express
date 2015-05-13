class Tag < ActiveRecord::Base
  has_many :posts
  has_many :posts, :through => :post_tags
  translates :name
  default_scope {includes(:translations)}
end
