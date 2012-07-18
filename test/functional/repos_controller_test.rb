require 'test_helper'

class ReposControllerTest < ActionController::TestCase

  test "new not logged in" do
    get :new
    assert_redirected_to auth_github_url
  end

  test "new logged in" do
    sign_in FactoryGirl.create(:user)
    get :new
    assert_response :success
  end

  test "create validation error" do
    sign_in FactoryGirl.create(:user)
    assert_no_difference 'Repo.count' do
      post :create, :repo => Hash.new
    end

    assert_response :unprocessable_entity
  end

  test "create success" do
    user = FactoryGirl.create(:user)
    sign_in user

    assert_difference 'Repo.count' do
      post :create, :repo => {:name => 'lolcommits' }
    end

    repo = Repo.last
    assert_redirected_to repo_path(repo)
    assert_equal 'lolcommits', repo.name
    assert_equal [user], repo.users
    assert_not_nil repo.external_id
  end

  test "show not found" do
    sign_in FactoryGirl.create(:user)
    get :show, :id => 'omg'
    assert_response :not_found
  end

  test "show success" do
    sign_in FactoryGirl.create(:user)
    repo = FactoryGirl.create(:repo)
    get :show, :id => repo.id
    assert_response :success
  end

  test "show works logged out too" do
    repo = FactoryGirl.create(:repo)
    get :show, :id => repo.id
    assert_response :success
  end

end