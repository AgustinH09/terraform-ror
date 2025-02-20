class HealthController < ApplicationController
  def index
    render json: { status: 'OK' }
  end
end

