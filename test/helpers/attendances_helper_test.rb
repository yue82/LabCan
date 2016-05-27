require 'test_helper'

class AttendancesHelperTest < ActionView::TestCase
  def setup
    @user1 = users(:michael)
    @user1.update_check_token
    @user1.attendance = attendances(:michael)
    @user2 = users(:archer)
    @user2.update_check_token
    @user2.attendance = attendances(:archer)
    @user3 = users(:lana)
    @user3.update_check_token
    @user3.attendance = attendances(:lana)
  end

  test "should return last one user" do
    @user1.attendance.checkin
    @user2.attendance.checkin
    @user3.attendance.checkin

    @user3.attendance.checkout
    assert_nil last_one_user
    @user2.attendance.checkout
    assert_equal last_one_user, @user1

  end





end
