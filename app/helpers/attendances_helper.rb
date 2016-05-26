module AttendancesHelper
  def checked_in?
    current_user.attendance.attend
  end

end
