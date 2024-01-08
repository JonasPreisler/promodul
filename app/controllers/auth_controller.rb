class AuthController < ApplicationController
  skip_before_action :validate_authentication

  def send_email
    Thread.new do
      InfoMailer.new_client(info_params).deliver
    end
    render json: { success: true }, status: 201
  end

  def login
    unless bearer_token
      errors = Auth::Service.new.check_params(auth_params)

      if errors.any?
        render json: { errors: errors }, status: 400
        return
      end
    end
    @result = Auth::Service.new(client_headers).auth_current_user!(auth_params)
    json_view
  end

  def refresh_token
    @result = Auth::Service.new(client_headers).refresh_token!
    json_view
  end

  def logout
    @result = Auth::Service.new(client_headers).destroy_token!
    json_view
  end

  def json_view

    if @result.success?
      render json: @result[:content][:data], status: @result[:status_code]
    else
      render json: @result[:content], status: @result[:status_code]
    end
  end

  private

    def info_params
      params.permit(:email, :phone)
    end

    def auth_params
      params.require(:auth).permit(:username, :password, :device_token)
    end

    def bearer_token
      pattern = /^Bearer /
      header  = request.headers["Authorization"]
      header.gsub(pattern, '') if header&.match(pattern)
    end

    def client_headers
      {
          ip: request.env['HTTP_CLIENT_IP'] || request.remote_ip,
          user_agent: request.env['HTTP_USER_AGENT'],
          bearer_token: bearer_token
      }
    end
end