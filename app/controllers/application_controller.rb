class ApplicationController < ActionController::API
  include RateThrottler

  private

  def throttle_requests!
    throttle_result = perform_throttle_check

    if throttle_result[:throttle]
      render status: 429, json: { message: "Rate limit exceeded. Try again in #{throttle_result[:seconds_until_limit_lifted]} seconds" }
    end
  end
end
