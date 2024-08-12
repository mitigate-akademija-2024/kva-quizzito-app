require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get pages_start_url
    assert_response :success
  end
end
