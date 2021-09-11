class OwnerInfosController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  skip_before_action :validate_authentication

  def send_email
    Thread.new do
      InfoMailer.new_client(info_params).deliver
    end
    render json: { success: true }, status: 201
  end

  private

  def info_params
    params.permit(:email, :phone)
  end
end
