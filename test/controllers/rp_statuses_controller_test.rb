require 'test_helper'

class RpStatusesControllerTest < ActionController::TestCase
  setup do
    @rp_status = rp_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rp_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rp_status" do
    assert_difference('RpStatus.count') do
      post :create, rp_status: { color: @rp_status.color, description: @rp_status.description, name: @rp_status.name }
    end

    assert_redirected_to rp_status_path(assigns(:rp_status))
  end

  test "should show rp_status" do
    get :show, id: @rp_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rp_status
    assert_response :success
  end

  test "should update rp_status" do
    patch :update, id: @rp_status, rp_status: { color: @rp_status.color, description: @rp_status.description, name: @rp_status.name }
    assert_redirected_to rp_status_path(assigns(:rp_status))
  end

  test "should destroy rp_status" do
    assert_difference('RpStatus.count', -1) do
      delete :destroy, id: @rp_status
    end

    assert_redirected_to rp_statuses_path
  end
end
