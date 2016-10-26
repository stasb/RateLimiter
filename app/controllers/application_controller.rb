class ApplicationController < ActionController::API
  include RateThrottler
end
