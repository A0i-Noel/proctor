require "test_helper"

class RoleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_role_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_role_show_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_role_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_role_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_role_destroy_url
    assert_response :success
  end
end
