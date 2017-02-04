require 'test_helper'

class HeadhunterControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get headhunter_index_url
    assert_response :success
  end

end
