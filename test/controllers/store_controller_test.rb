require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index in supported languages" do
    get store_index_url, params: { locale: 'en' }
    assert_response :success
    assert_select 'nav.side_nav a', minimum: 4
    assert_select 'main ul.catalog li', 3
    assert_select 'h2', 'Programming Ruby 1.9'
    assert_select '.price', /\$[,\d]+\.\d\d/
  end
  test "should get index in nonsupported languages" do
    get store_index_url, params: { locale: 'pl' }
    assert_response :success
    assert_select '#notice', "pl translation not available"
  end
end
