class Training < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug

  has_many :screen_casts
end
