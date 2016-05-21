require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @user = users(:lana)
  end

  test "index as admin and delete links" do
    log_in_as(@admin)
    get users_path
    assert_select 'a[href=?]', user_path(@user), text: @user.name
    assert_template 'users/index'
    assert_select 'a[href=?]', user_path(@user), text: 'delete'
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
