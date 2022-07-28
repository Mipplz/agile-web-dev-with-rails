class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  # CR: [matik] kluczami w enumie powinny być Symbole a w widokach użyte I18n
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }
  # CR: [garbus] - TO JEST ZAJEBISTE!
  enum payment_status: {
    unpaid: 0,
    preauthorized: 1,
    executed: 2,
    rejected: 3,
    accepted: 4
  }
  validates :name, :address, :email, presence: true
  # CR: [matik] Bardzo sprytne użycie metod
  # zdefiniowanych przez `enum`
  validates :pay_type, inclusion: pay_types.keys
  # CR: [garbus] Zajebiste ze japierdol
  validates :payment_status, inclusion: payment_statuses.keys

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
