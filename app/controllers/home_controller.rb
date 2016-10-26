class HomeController < ApplicationController
  before_filter :throttle_requests!

  def index
    render status: 200, json: { message: 'ok' }
  end
end
