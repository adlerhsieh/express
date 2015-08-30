module FactoryHelpers
  def create_factory
    Store::Order.find_by_id(1)         || create(:store_order)
    Store::PaymentMethod.find_by_id(1) || create(:store_payment_method)
    User.find_by_id(1)                 || create(:user)
  end
end
