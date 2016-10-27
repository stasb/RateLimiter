class ThrottleLogCleaner
  def self.clean_throttle_logs
    ThrottleLog.where('expiry_time < ?', Time.now).destroy_all
  end
end
