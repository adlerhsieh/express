class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:github]
  has_one :address, :class_name => "User::Mail"
  has_many :orders, :class_name => "Store::Order"
  require 'bing_translator'

  def latest_order
    orders.where(:aasm_state => ["cart","placed"]).order(:updated_at => :desc).first
  end

  def has_cart?
    self.orders.where(:aasm_state => "cart").order(:updated_at => :desc).first
  end

  def cart
    order = self.orders.where(:aasm_state => "placed").order(:updated_at => :desc).first
    return order if order
    @cart ||= self.orders.where(:aasm_state => "cart").order(:updated_at => :desc).first
    if not @cart
      @cart = self.orders.new
      @cart.save!
    end
    return @cart
  end

  def is_admin?
    is_admin
  end

  def self.find_by_omniauth(auth)
    find_by(provider: auth["provider"], uid: auth["uid"])
  end 

end
