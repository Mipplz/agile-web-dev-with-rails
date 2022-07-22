require 'test_helper'

class PaymentControllerTest < ActionDispatch::IntegrationTest
  setup do
    order = orders(:one)
    post orders_url, params: { order: { address: order.address, email: order.email, name: order.name, pay_type: order.pay_type } }
  end
  test "should get index" do
    get payment_url
    assert_response :success
  end
end
