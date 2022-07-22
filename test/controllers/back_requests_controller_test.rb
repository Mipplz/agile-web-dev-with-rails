require 'test_helper'

class BackRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    order = orders(:one)
    post orders_url, params: { order: { address: order.address, email: order.email, name: order.name, pay_type: order.pay_type } }
  end
  def basic_auth(name, password)
    ActionController::HttpAuthentication::Basic.encode_credentials(name, password)
  end
  test "should accept request and update order" do
    auth = basic_auth(::BACK_REQUEST_SETTINGS['login'], ::BACK_REQUEST_SETTINGS['password'])
    post back_requests_url, headers: { Authorization: auth }, params: {
      "subject": "payment",
      "description": "order:#{orders(:one).id}",
      "state": "executed",
      "issuer_response_code": "00"
    }
    assert_response :success
    db_order = Order.find(orders(:one).id)
    assert_equal '00', db_order["issuer_response_code"]
    assert_equal 'executed', db_order["payment_status"]
  end
  test "should reject request" do
    post back_requests_url
    assert_response 401

    auth = basic_auth('asd', 'asd')
    post back_requests_url, headers: { Authorization: auth }
    assert_response 401
  end
end
