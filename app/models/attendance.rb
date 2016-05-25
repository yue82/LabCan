class Attendance < ActiveRecord::Base
  belongs_to :user

  def checkin
    update_attribute(:attend, true)
  end

  def checkout
    update_attribute(:attend, false)
  end

end
