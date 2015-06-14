class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:github]
  has_many :orders, :class_name => "Store::Order"
  require 'bing_translator'

  def cart
    @cart ||= Store::Order.where(:aasm_state => "cart").order(:updated_at => :desc).first
    if not @cart
      @cart = Store::Order.new
      @cart.save!
    end
    return @cart
  end

  def is_admin?
    is_admin
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      # user.image = auth.info.image
    end
  end
end
