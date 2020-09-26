class CurrenciesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def list
    service = General::CurrenciesService.new(currency_params)
    service.list
    rest_respond_service service
  end

  private

  def currency_params
    params.permit(:id)
  end
end
