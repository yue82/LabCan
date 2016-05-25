require 'test_helper'
require 'json'


module Api
  module V1
    class AttendancesControllerTest < ActionController::TestCase
      def setup
        @user = users(:michael)
        @user.update_check_token
        @user.attendance = attendances(:michael)
      end

      test "should get welcome message once when correct user login" do
        # get :api_v1_checkin, { check_token: @user.check_token }.to_json
        # assert_response :success
        # response_json = JSON.parse(@response.body)
        # assert_equal response_json["msg"], "Welcome to Lab"
        # assert_equal @user.attendance.attend, true

        # get :api_v1_checkin, @user.check_token.to_json
        # assert_response :noupdate
        # response_json = JSON.parse(@response.body)
        # assert_equal response_json["msg"], "Already checked in"
      end

    end
  end
end
