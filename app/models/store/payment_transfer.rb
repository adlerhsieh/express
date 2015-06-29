class Store::PaymentTransfer < ActiveRecord::Base
  belongs_to :order, :class_name => "Store::Order", :foreign_key => "order_id"
  before_create :default_values
  validates_presence_of :transaction_id

  def default_values
    self.status = "Pending" unless self.status
    self.confirm = false unless self.confirm
    return true
  end

  def confirm!
    self.update_column(:confirm, true)
    self.update_column(:confirm_time, Time.now)
  end
end
