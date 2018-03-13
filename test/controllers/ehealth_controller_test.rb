require 'test_helper'

class EhealthControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ehealth_index_url
    assert_response :success
  end

end
