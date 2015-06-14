class Store::Order < ActiveRecord::Base
  belongs_to :user
  has_many :items, :class_name => "Store::OrderItem", :foreign_key => "order_id"
  include AASM
  before_save :generate_token, :set_paid_false

  def generate_token
    self.token = SecureRandom.hex if not self.token
  end

  def set_paid_false
    self.paid = false if self.paid.nil?
  end

  def add_item(product_id)
    item = self.items.find_by_product_id(product_id)
    if item
      quantity = item.quantity
      item.update_column(:quantity, quantity + 1)
    else
      product = Store::Product.find(product_id)
      item = self.items.create(:product_id => product.id, 
                        :quantity => 1,
                        :price => product.price
                       )
    end
    {title: item.product.title, quantity: item.quantity, price: item.price}
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
    event :checkout do
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
