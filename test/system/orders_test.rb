require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "creating a Order" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    visit orders_url
    click_on "New Order"

    fill_in "Name", with: @order.name
    fill_in "Address", with: @order.address
    fill_in "E-mail", with: @order.email
    select @order.pay_type, from: "Pay with"
    click_on "Place Order"

    assert_text "Choose payment method"
  end

  test "updating a Order" do
    visit orders_url
    click_on "Edit", match: :first

    fill_in "Name", with: @order.name
    fill_in "Address", with: @order.address
    fill_in "E-mail", with: @order.email
    select @order.pay_type, from: "Pay with"
    click_on "Place Order"

    assert_text "Order was successfully updated."
    click_on "Back"
  end

  test "destroying a Order" do
    visit orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed."
  end
end
