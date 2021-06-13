class PlannerOwnersController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def dashboard
    service = Owners::Dashboard.new(owners_params)
    service.call
    rest_respond_service service
  end

  def companies
    service = Owners::CompanyServices.new(owners_params)
    service.company_list
    rest_respond_service service
  end

  def stop_license
    service = Owners::CompanyServices.new(owners_params)
    service.deactivate_company
    rest_respond_service service
  end

  def activate_license
    service = Owners::CompanyServices.new(owners_params)
    service.activate_company
    rest_respond_service service
  end

  def register_company

  end

  private

  def owners_params
    params.permit(:company_id)
  end
end
