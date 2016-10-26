module RateThrottler
  class Limiter
    def perform_throttling
    end
  end

  def throttle_requests!
    limiter = Limiter.new

    limiter.perform_throttling
  end
end
