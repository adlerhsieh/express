class Screencast < ActiveRecord::Base

  extend FriendlyId
  include DefaultSetter

  belongs_to :training
  belongs_to :category

  before_save :default_columns
  after_save :default_display_date, :default_category

  friendly_id :slug

  scope :independent, -> { where(training_id: nil) }
  scope :is_public, -> { where(is_public: true) }

  def tags
    []
  end

  def thumbnail
    icon.presence || category.image
  end
end
