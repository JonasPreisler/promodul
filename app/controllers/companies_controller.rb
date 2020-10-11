class CompaniesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Companies::CompaniesService.new(company_params)
    service.create_company
    rest_respond_service service
  end

  def update
    service = Companies::CompaniesService.new(company_params)
    service.update_company
    rest_respond_service service
  end

  def destroy
    service = Companies::CompaniesService.new(company_params)
    service.destroy
    rest_respond_service service
  end

  def show
    service = Companies::CompaniesService.new(company_params)
    service.show
    rest_respond_service service
  end

  def company_list
    service = Companies::CompaniesService.new(company_params)
    service.company_list
    rest_respond_service service
  end

  def sub_company_list
    service = Companies::CompaniesService.new(company_params)
    service.sub_company_list
    rest_respond_service service
  end

  private

  def company_params
    params.permit(:id, :name, :description, :address, :phone_number, :country_id, :city_id, :parent_id)
  end
end
