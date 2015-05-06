class Training < ActiveRecord::Base
  has_many :screen_casts
  before_save :default_columns
  after_save :default_display_date
  extend FriendlyId
  friendly_id :slug
  include DefaultSetter
end
