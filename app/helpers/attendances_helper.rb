module AttendancesHelper
  SLACK_SETTINGS = Rails.application.config_for(:slack_settings)
  def checked_in?
    current_user.attendance.attend
  end

  def last_one_user
    remain_users = Attendance.where(attend: true)
    remain_users.count == 1 ? remain_users[0].user : nil
  end

  def announce_last(user)
    if user
      msg = "窓とベランダの扉を閉めて，エアコンと電気を消して帰ってくださいね！"
      slack = Slack::Incoming::Webhooks.new SLACK_SETTINGS['hook_url'],
                                            channel: user.slack_channel
      slack.post msg
    end
  end

end
