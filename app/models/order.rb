class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }
  enum payment_status: {
    unpaid: 0,
    preauthorized: 1,
    executed: 2,
    rejected: 3
  }
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys
  validates :payment_status, inclusion: payment_statuses.keys

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
