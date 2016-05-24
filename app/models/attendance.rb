class Attendance < ActiveRecord::Base
  belongs_to :user

  def labin
    update_attribute(:attend, true)
  end

  def labout
    update_attribute(:attend, false)
  end

end
