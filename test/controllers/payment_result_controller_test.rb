require 'test_helper'

class PaymentResultControllerTest < ActionDispatch::IntegrationTest
  setup do
    order = orders(:one)
    post orders_url, params: { order: { address: order.address, email: order.email, name: order.name, pay_type: order.pay_type } }
  end
  test "should redirect to store afeter payment success" do
    get payment_result_success_url
    assert_redirected_to store_index_url(locale: I18n.locale)
  end
  test "should redirect to payment after payment failure" do
    get payment_result_failure_url
    assert_redirected_to payment_url(locale: I18n.locale)
  end
end
