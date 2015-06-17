class Store::Order < ActiveRecord::Base
  belongs_to :user
  has_many :items, :class_name => "Store::OrderItem", :foreign_key => "order_id"
  has_one :info, :class_name => "Store::OrderInfo", :foreign_key => "order_id"
  include AASM
  extend FriendlyId
  friendly_id :token
  before_save :generate_token, :set_paid_false

  def generate_token
    self.token = SecureRandom.hex if not self.token
    true
  end

  def set_paid_false
    self.paid = false if self.paid.nil?
    true
  end

  def add_item(product_id)
    item = self.items.find_by_product_id(product_id)
    if item
      quan = item.quantity + 1
      item.update_column(:quantity, quan)
      # item.update_column(:price, quan*item.price)
    else
      product = Store::Product.find(product_id)
      item = self.items.create(:product_id => product.id, 
                        :quantity => 1,
                        :price => product.price
                       )
    end
    self.update_total_price
    {title: item.product.title, quantity: item.quantity, price: item.price}
  end

  def update_order_time
    self.update_column(:order_time, Time.now)
  end

  def update_total_price
    total_price = self.items.inject(0){|r,item|
      r += (item.quantity * item.price)
    }
    self.update_column(:price, total_price)
  end

  aasm do
    state :outdated
    state :cart, :initial => true
    state :placed
    state :paid
    state :shipped
    state :arrived
    state :cancelled
    state :returned

    event :outdate do
      transitions from: [:cart, :placed], to: :outdated
    end
    event :place do
      transitions from: :cart, to: :placed
    end
    event :pay do
      transitions from: :placed, to: :paid
    end
    event :ship do
      transitions from: :paid, to: :shipped
    end
    event :arrive do
      transitions from: :shipped, to: :arrived
    end
    event :cancel do
      transitions from: [:cart, :placed, :paid], to: :cancelled
    end
    event :return do
      transitions from: :arrived, to: :returned
    end
  end
end
