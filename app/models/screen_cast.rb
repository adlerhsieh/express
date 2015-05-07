class ScreenCast < ActiveRecord::Base
  belongs_to :training
  belongs_to :category
  before_save :default_columns
  after_save :default_display_date, :default_category
  extend FriendlyId
  friendly_id :slug
  include DefaultSetter
end
