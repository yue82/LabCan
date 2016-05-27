class Attendance < ActiveRecord::Base
  belongs_to :user

  def checkin
    if self.attend
      return :info, { msg: "Already checked in" }
    else
      update_attribute(:attend, true)
      return :success, { msg: "Welcome to Lab" }
    end
  end

  def checkout
    if self.attend
      update_attribute(:attend, false)
      return :success, { msg: "Goodbye" }
    else
      return :info, { msg: "Already checked out" }
    end
  end

end
