require 'test_helper'

class SpacetimePositionsControllerTest < ActionController::TestCase
  setup do
    @spacetime_position = spacetime_positions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spacetime_positions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spacetime_position" do
    assert_difference('SpacetimePosition.count') do
      post :create, spacetime_position: { begin_at: @spacetime_position.begin_at, end_at: @spacetime_position.end_at, latitude: @spacetime_position.latitude, longitude: @spacetime_position.longitude, resume: @spacetime_position.resume, subtitle: @spacetime_position.subtitle, title: @spacetime_position.title, topic_id: @spacetime_position.topic_id, weather: @spacetime_position.weather }
    end

    assert_redirected_to spacetime_position_path(assigns(:spacetime_position))
  end

  test "should show spacetime_position" do
    get :show, id: @spacetime_position
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spacetime_position
    assert_response :success
  end

  test "should update spacetime_position" do
    patch :update, id: @spacetime_position, spacetime_position: { begin_at: @spacetime_position.begin_at, end_at: @spacetime_position.end_at, latitude: @spacetime_position.latitude, longitude: @spacetime_position.longitude, resume: @spacetime_position.resume, subtitle: @spacetime_position.subtitle, title: @spacetime_position.title, topic_id: @spacetime_position.topic_id, weather: @spacetime_position.weather }
    assert_redirected_to spacetime_position_path(assigns(:spacetime_position))
  end

  test "should destroy spacetime_position" do
    assert_difference('SpacetimePosition.count', -1) do
      delete :destroy, id: @spacetime_position
    end

    assert_redirected_to spacetime_positions_path
  end
end
