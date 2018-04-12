class Training < ActiveRecord::Base

  extend FriendlyId
  include DefaultSetter

  has_many :screencasts
  belongs_to :category
  before_save :default_columns
  after_save :default_display_date, :default_category, :translate_CN

  friendly_id :slug

  def tags
    []
  end
end
