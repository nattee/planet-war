require 'test_helper'

class LeaderboardControllerTest < ActionController::TestCase
  test "should get recent" do
    get :recent
    assert_response :success
  end

  test "should get ranking" do
    get :ranking
    assert_response :success
  end

end
