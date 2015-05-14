class Screencast < ActiveRecord::Base
  belongs_to :training
  belongs_to :category
  before_save :default_columns
  after_save :default_display_date, :default_category, :translate
  translates :title, :content
  default_scope {includes(:translations)}
  extend FriendlyId
  friendly_id :slug
  include DefaultSetter

  def tags
    []
  end

  def translate
    Translator.new(self).to_CN
  end
end
