class HomeController < ApplicationController
  before_action :throttle_requests!

  def index
    render status: 200, json: { message: 'ok' }
  end
end
