class ResourcesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Resources::ResourcesService.new(resource_params)
    service.create_resource
    rest_respond_service service
  end

  def resource_list
    service = Resources::ResourcesService.new(resource_params)
    service.resource_list
    rest_respond_service service
  end

  def resource_type_list
    service = Resources::ResourcesService.new(resource_params)
    service.resource_type_list
    rest_respond_service service
  end

  def update
    service = Resources::ResourcesService.new(resource_params)
    service.update_resource
    rest_respond_service service
  end
  #
  #def destroy
  #  service = Companies::CompaniesService.new(company_params)
  #  service.destroy
  #  rest_respond_service service
  #end
  #
  #def show
  #  service = Companies::CompaniesService.new(company_params)
  #  service.show
  #  rest_respond_service service
  #end
  #
  #def company_list
  #  service = Companies::CompaniesService.new(company_params)
  #  service.company_list
  #  rest_respond_service service
  #end
  #
  #def sub_company_list
  #  service = Companies::CompaniesService.new(company_params)
  #  service.sub_company_list
  #  rest_respond_service service
  #end

  private

  def resource_params
    params.permit(:id, :name, :description, :resource_type_id, :model_on_type, :model_on_id)
  end
end
