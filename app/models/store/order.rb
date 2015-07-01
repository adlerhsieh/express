class Store::Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment_method, :class_name => "Store::PaymentMethod", :foreign_key => "payment_method_id"
  has_many :items, :class_name => "Store::OrderItem", :foreign_key => "order_id", :dependent => :destroy
  has_many :notifiers, :class_name => "Store::PaymentNotifier", :foreign_key => "order_id", :dependent => :destroy
  has_one :transfer, :class_name => "Store::PaymentTransfer", :foreign_key => "order_id", :dependent => :destroy
  has_one :info, :class_name => "Store::OrderInfo", :foreign_key => "order_id"
  include AASM
  extend FriendlyId
  friendly_id :token
  before_save :generate_token, :set_paid_false

  def has_info
    info = self.info
    return false if not info
    return false if info.shipping_name.nil? || 
                    info.shipping_name.blank? ||
                    info.shipping_address.nil? || 
                    info.shipping_address.blank? ||
                    info.phone.nil? ||
                    info.phone.blank?
    true
  end

  def stock_ready
    ready = true
    self.items.each do |i|
      if i.quantity > i.product.stock
        ready = false
        break
      end
    end
    return ready
  end

  def use_paypal
    id = Store::PaymentMethod.find_by_method("PayPal").id
    update_column(:payment_method_id, id)
  end

  def use_transfer
    id = Store::PaymentMethod.find_by_method("匯款").id
    update_column(:payment_method_id, id)
  end

  def clear_payment_method
    update_column(:payment_method_id, nil)
  end

  def generate_token
    self.token = SecureRandom.hex if not self.token
    true
  end

  def set_paid_false
    self.paid = false if self.paid.nil?
    true
  end

  def paypal_url(return_url)
    url = Rails.application.routes.url_helpers.store_payment_notifiers_url(:host => ENV["paypal_returning_host"])
    values = {
      :business => ENV["paypal_seller_email"],
      :cmd => "_cart",
      :upload => "1",
      :currency_code => "TWD",
      :return => return_url,
      :invoice => id,
      :notify_url => url,
      :cert_id => ENV["paypal_cert_id"]
    } 
    items.each_with_index do |item, index|
      values.merge!({
        "amount_#{index+1}" => item.price,
        "item_name_#{index+1}" => item.product.title,
        "item_number_#{index+1}" => item.id,
        "quantity_#{index+1}" => item.quantity
      })
    end
    # "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
    encrypt_for_paypal(values)
  end

  def encrypt_for_paypal(values)
    paypal_cert_pem = File.read("#{Rails.root}/certs/paypal_cert.pem")
    app_cert_pem = File.read("#{Rails.root}/certs/app_cert.pem")
    app_key_pem = File.read("#{Rails.root}/certs/app_key.pem")
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(app_cert_pem), OpenSSL::PKey::RSA.new(app_key_pem, ''), values.map { |k, v| "#{k}=#{v}"  }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(paypal_cert_pem)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
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

  def timestamp(time)
    self.update_column(time, Time.now)
  end

  def clear_timestamp(time)
    self.update_column(time, nil)
  end

  def update_pay_time
    self.update_column(:paid, true)
    self.update_column(:pay_time, Time.now)
  end

  def update_total_price
    total_price = self.items.inject(0){|r,item|
      r += (item.quantity * item.price)
    }
    self.update_column(:price, total_price)
  end

  def not_transferring_or_paid?
    self.cart? || self.placed?
  end

  def under_shipping?
    self.paid? || self.shipped? || self.arrived? || self.returned?
  end

  def may_return?
    self.arrived? || self.returned?
  end

  aasm do
    state :outdated
    state :cart, :initial => true
    state :placed
    state :transferred
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
    event :cancel_transfer do
      transitions from: :transferred, to: :placed
    end
    event :under_transfer do
      transitions from: [:placed, :paid], to: :transferred
    end
    event :pay do
      transitions from: [:placed,:transferred], to: :paid
    end
    event :ship do
      transitions from: :paid, to: :shipped
    end
    event :cancel_ship do
      transitions from: :shipped, to: :paid
    end
    event :arrive do
      transitions from: :shipped, to: :arrived
    end
    event :cancel_arrive do
      transitions from: :arrived, to: :shipped
    end
    event :cancel do
      transitions from: [:cart, :placed, :paid], to: :cancelled
    end
    event :return do
      transitions from: :arrived, to: :returned
    end
    event :cancel_return do
      transitions from: :returned, to: :arrived
    end
  end
end
