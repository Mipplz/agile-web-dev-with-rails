json.extract! order, :id, :name, :address, :email, :pay_type, :payment_status, :reject_reason, :issuer_response_code, :created_at, :updated_at
json.url order_url(order, format: :json)
