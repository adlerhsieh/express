class Store::PaymentNotifier < ActiveRecord::Base
  belongs_to :order, :class_name => "Store::Order", :foreign_key => "order_id"

  def pending?
    return true if self.status == "Pending"
  end

  def cancelled?
    return true if self.status == "Cancelled"
  end
end
