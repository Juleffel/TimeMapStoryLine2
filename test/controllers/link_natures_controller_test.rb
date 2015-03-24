require 'test_helper'

class LinkNaturesControllerTest < ActionController::TestCase
  setup do
    @link_nature = link_natures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:link_natures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create link_nature" do
    assert_difference('LinkNature.count') do
      post :create, link_nature: { color: @link_nature.color, description: @link_nature.description, name: @link_nature.name }
    end

    assert_redirected_to link_nature_path(assigns(:link_nature))
  end

  test "should show link_nature" do
    get :show, id: @link_nature
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @link_nature
    assert_response :success
  end

  test "should update link_nature" do
    patch :update, id: @link_nature, link_nature: { color: @link_nature.color, description: @link_nature.description, name: @link_nature.name }
    assert_redirected_to link_nature_path(assigns(:link_nature))
  end

  test "should destroy link_nature" do
    assert_difference('LinkNature.count', -1) do
      delete :destroy, id: @link_nature
    end

    assert_redirected_to link_natures_path
  end
end
