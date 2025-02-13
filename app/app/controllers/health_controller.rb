# frozen_string_literal: true

class HealthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def check
    render json: { status: "OK" }, status: :ok
  end
end

