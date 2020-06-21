class HealthController < ActionController::Base
  def check_health
    render json: { }, status: 200
  end
end
