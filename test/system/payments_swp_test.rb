require "application_system_test_case"

def setup_order_for_payment
  visit store_index_url

  click_on 'Add to Cart', match: :first
  click_on 'Checkout'

  fill_in 'order_name', with: 'Dave Thomas'
  fill_in 'order_address', with: '123 Main Street'
  fill_in 'order_email', with: 'dave@example.com'
  select "Check", from: 'order_pay_type'
  click_on 'Place Order'
end

class PaymentsSwpTest < ApplicationSystemTestCase
  setup do
    setup_order_for_payment
    @common_data = { "first_name" => 'Michał',
                     "last_name" => 'Zmudziński',
                     "year_long" => "2025",
                     "year_short" => "25",
                     "state_executed" => "01",
                     "state_rejected" => "12",
                     "verification_value" => "123" }
    @card1 = "4242424242424242"
    @card2 = "4012000000020006"
    @card3 = "4012888888881881"
    @card4 = "4242421111112239"
  end

  test "visiting the index" do
    visit payment_url
    assert_selector "h1", text: "Choose payment method"
  end
  test "payment executed card without 3DS/eDCC SWP" do
    visit payment_url
    click_on "Continue", match: :first

    within :css, "div.dropdown" do
      click_link
    end
    click_link 'English'

    fill_in "First name", with: @common_data['first_name']
    fill_in "Last name", with: @common_data['last_name']
    fill_in "Number", with: @card1
    fill_in "CVV/CVC", with: @common_data["verification_value"]
    select @common_data['state_executed'], from: "transaction_credit_card_attributes_month"
    select @common_data["year_short"], from: "transaction_credit_card_attributes_year"

    click_on "Next ❯"

    assert_text "executed"
    # click_on "Back to shop"
    # assert_text "Thank you for your order"
  end
  test "payment rejected card without 3DS/eDCC SWP" do
    visit payment_url
    click_on "Continue", match: :first

    within :css, "div.dropdown" do
      click_link
    end
    click_link 'English'

    fill_in "First name", with: @common_data['first_name']
    fill_in "Last name", with: @common_data['last_name']
    fill_in "Number", with: @card1
    fill_in "CVV/CVC", with: @common_data["verification_value"]
    select @common_data['state_rejected'], from: "transaction_credit_card_attributes_month"
    select @common_data["year_short"], from: "transaction_credit_card_attributes_year"

    click_on "Next ❯"

    assert_text "rejected"
    # click_on "Back to shop"
    # assert_text "Payment failed"
  end
  test "payment executed card with 3DS SWP" do
    visit payment_url
    click_on "Continue", match: :first

    within :css, "div.dropdown" do
      click_link
    end
    click_link 'English'

    fill_in "First name", with: @common_data['first_name']
    fill_in "Last name", with: @common_data['last_name']
    fill_in "Number", with: @card2
    fill_in "CVV/CVC", with: @common_data["verification_value"]
    select @common_data['state_executed'], from: "transaction_credit_card_attributes_month"
    select @common_data["year_short"], from: "transaction_credit_card_attributes_year"
    click_on "Next ❯"

    assert_text "3D-Secure Authorization"
    page.has_content?("3D-Secure 2 Payment - simulation")

    within_frame 'challenge_iframe' do
      assert_text "3D-Secure 2 Payment - simulation"
      find('#confirm-btn').click
      assert_text "Request Sent"
    end

    assert_text "executed"
    # click_on "Back to shop"
    # assert_text "Thank you for your order"
  end
  test "payment rejected card with 3DS SWP" do
    visit payment_url
    click_on "Continue", match: :first

    within :css, "div.dropdown" do
      click_link
    end
    click_link 'English'

    fill_in "First name", with: @common_data['first_name']
    fill_in "Last name", with: @common_data['last_name']
    fill_in "Number", with: @card2
    fill_in "CVV/CVC", with: @common_data["verification_value"]
    select @common_data['state_rejected'], from: "transaction_credit_card_attributes_month"
    select @common_data["year_short"], from: "transaction_credit_card_attributes_year"

    click_on "Next ❯"
    assert_text "3D-Secure Authorization"

    page.has_content?("3D-Secure 2 Payment - simulation")

    within_frame 'challenge_iframe' do
      assert_text "3D-Secure 2 Payment - simulation"
      find('#confirm-btn').click
      assert_text "Request Sent"
    end

    assert_text "rejected"
    # click_on "Back to shop"
    # assert_text "Payment failed"
  end
  test "payment executed card with 3DS+DCC SWP" do
    visit payment_url
    click_on "Continue", match: :first

    within :css, "div.dropdown" do
      click_link
    end
    click_link 'English'

    fill_in "First name", with: @common_data['first_name']
    fill_in "Last name", with: @common_data['last_name']
    fill_in "Number", with: @card3
    fill_in "CVV/CVC", with: @common_data["verification_value"]
    select @common_data['state_executed'], from: "transaction_credit_card_attributes_month"
    select @common_data["year_short"], from: "transaction_credit_card_attributes_year"
    click_on "Next ❯"

    find("#dcc_yes").click
    click_on "Next ❯"

    page.has_no_content?("3D-Secure Authorization")
    assert_text "3D-Secure Redirect"

    assert_text "Płatność kartą 3D-Secure — symulacja"
    fill_in "Kod/hasło:", with: '1234'
    click_on "Prześlij | Send"

    # assert_text "Thank you for your order"
  end
  test "payment rejected card with 3DS+DCC SWP" do
    visit payment_url
    click_on "Continue", match: :first

    within :css, "div.dropdown" do
      click_link
    end
    click_link 'English'

    fill_in "First name", with: @common_data['first_name']
    fill_in "Last name", with: @common_data['last_name']
    fill_in "Number", with: @card3
    fill_in "CVV/CVC", with: @common_data["verification_value"]
    select @common_data['state_rejected'], from: "transaction_credit_card_attributes_month"
    select @common_data["year_short"], from: "transaction_credit_card_attributes_year"
    click_on "Next ❯"

    find("#dcc_yes").click
    click_on "Next ❯"

    page.has_no_content?("3D-Secure Authorization")
    assert_text "3D-Secure Redirect"

    assert_text "Płatność kartą 3D-Secure — symulacja"
    fill_in "Kod/hasło:", with: '1234'
    click_on "Prześlij | Send"

    # assert_text "Payment failed"
  end
  test "payment executed card with DCC SWP" do
    visit payment_url
    click_on "Continue", match: :first

    within :css, "div.dropdown" do
      click_link
    end
    click_link 'English'

    fill_in "First name", with: @common_data['first_name']
    fill_in "Last name", with: @common_data['last_name']
    fill_in "Number", with: @card4
    fill_in "CVV/CVC", with: @common_data["verification_value"]
    select @common_data['state_executed'], from: "transaction_credit_card_attributes_month"
    select @common_data["year_short"], from: "transaction_credit_card_attributes_year"
    click_on "Next ❯"

    find("#dcc_yes").click
    click_on "Next ❯"

    assert_text "executed"
    click_on "Back to shop"

    # assert_text "Thank you for your order"
  end
  test "payment rejected card with DCC SWP" do
    visit payment_url
    click_on "Continue", match: :first

    within :css, "div.dropdown" do
      click_link
    end
    click_link 'English'

    fill_in "First name", with: @common_data['first_name']
    fill_in "Last name", with: @common_data['last_name']
    fill_in "Number", with: @card4
    fill_in "CVV/CVC", with: @common_data["verification_value"]
    select @common_data['state_rejected'], from: "transaction_credit_card_attributes_month"
    select @common_data["year_short"], from: "transaction_credit_card_attributes_year"
    click_on "Next ❯"

    find("#dcc_yes").click
    click_on "Next ❯"

    assert_text "rejected"
    # assert_text "Payment failed"
  end
end
