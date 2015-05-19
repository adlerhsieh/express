class Setting < ActiveRecord::Base
  translates :value
  default_scope {includes(:translations)}
  include DefaultSetter
  after_save :translate_CN
end
