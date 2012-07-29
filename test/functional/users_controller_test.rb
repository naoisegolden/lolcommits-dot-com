require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "account" do
    sign_in FactoryGirl.create(:user)
    get :account
    assert_response :success
  end

  test "show" do
    sign_in FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    get :show, :id => user2.id
    assert_response :success
    assert_equal user2.id, assigns[:selected_user].id
  end

  test "show not found" do
    sign_in FactoryGirl.create(:user)
    get :show, :id => 'omgomg'
    assert_response :not_found
  end
end
