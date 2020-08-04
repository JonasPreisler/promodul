class TermsAndConditionsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = TermsAndConditions::TermsAndConditionsService.new(terms_params)
    service.create
    rest_respond_service service
  end

  def list
    service = TermsAndConditions::TermsAndConditionsService.new(terms_params)
    service.list
    rest_respond_service service
  end

  private

  def terms_params
    params.permit(:id, :active_from, :version, :description, :terms_and_conditions)
  end
end
