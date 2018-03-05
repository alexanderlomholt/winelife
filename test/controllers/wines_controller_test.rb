require 'test_helper'

class WinesControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get wines_search_url
    assert_response :success
  end

  test "should get results" do
    get wines_results_url
    assert_response :success
  end

  test "should get show" do
    get wines_show_url
    assert_response :success
  end

end
