class Store::Order < ActiveRecord::Base
  include AASM

  aasm do
    state :cart, :initial => true
    state :placed
    state :paid
    state :shipped
    state :arrived
    state :cancelled
    state :returned

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
