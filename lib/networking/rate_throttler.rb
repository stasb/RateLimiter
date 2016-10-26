module RateThrottler
  class ThrottleChecker
    TIME_INTERVAL_LIMIT_SECONDS = 3600
    REQUEST_LIMIT = 100

    def initialize(ip_address)
      @ip_address = ip_address
      @throttle_log = ThrottleLog.find_by(ip_address: ip_address)

      @result = { throttle: false }
    end

    def check_for_throttling
      if @throttle_log.present?
        check_and_update_throttle_log
      else
        create_throttle_log
      end

      @result
    end

    private

    def check_and_update_throttle_log
      if Time.now > @throttle_log.expiry_time
        @throttle_log.update_attributes(expiry_time: Time.now + TIME_INTERVAL_LIMIT_SECONDS, count: 1)
      elsif @throttle_log.count >= REQUEST_LIMIT
        @result[:throttle] = true
        @result[:seconds_until_limit_lifted] = (@throttle_log.expiry_time - Time.now).round
      else
        current_count = @throttle_log.count

        @throttle_log.update_attributes(count: current_count + 1)
      end
    end

    def create_throttle_log
      ThrottleLog.create(ip_address: @ip_address, expiry_time: Time.now + TIME_INTERVAL_LIMIT_SECONDS, count: 1)
    end
  end

  def perform_throttle_check
    throttle_checker = ThrottleChecker.new(request.remote_ip.to_s)

    throttle_checker.check_for_throttling
  end
end
