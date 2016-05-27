require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @user.update_check_token
    @user.attendance = attendances(:michael)
  end

  test "should success check in once when correct user" do
    status, res = @user.attendance.checkin
    assert_equal status, :success
    assert_match res[:msg], "Welcome to Lab"

    status, res = @user.attendance.checkin
    assert_equal status, :info
    assert_match res[:msg], "Already checked in"
  end

  test "should success check out once when correct user" do
    status, res = @user.attendance.checkin
    assert_equal status, :success
    status, res = @user.attendance.checkout
    assert_equal status, :success
    assert_match res[:msg], "Goodbye"

    status, res = @user.attendance.checkout
    assert_equal status, :info
    assert_match res[:msg], "Already checked out"
  end

end
