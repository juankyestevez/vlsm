require 'test_helper'

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get main_index_url
    assert_response :success
  end

  test "should get sing_in" do
    get main_sing_in_url
    assert_response :success
  end

  test "should get sing_up" do
    get main_sing_up_url
    assert_response :success
  end

end
