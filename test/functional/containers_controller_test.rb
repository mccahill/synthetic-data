require 'test_helper'

class ContainersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get renew" do
    get :renew
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
