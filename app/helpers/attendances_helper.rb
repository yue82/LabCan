module AttendancesHelper
  def checked_in?
    current_user.attendance.attend
  end

  def last_one_user
    remain_users = Attendance.where(attend: true)
    remain_users.count == 1 ? remain_users[0].user : nil
  end

  def announce_last(user)
    if user
    end
  end


end
