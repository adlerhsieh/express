class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:github]
  has_one :address, :class_name => "User::Mail"
  require 'bing_translator'

  def is_admin?
    is_admin
  end

  def self.find_by_omniauth(auth)
    find_by(provider: auth["provider"], uid: auth["uid"])
  end 

end
