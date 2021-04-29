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

  def destroy
    service = Resources::ResourcesService.new(resource_params)
    service.destroy
    rest_respond_service service
  end

  def resource_calendar
    service = Resources::ResourcesService.new(resource_params)
    service.resource_calendar
    rest_respond_service service
  end

  def task_resource_list
    service = Resources::ResourcesService.new(task_resource_params)
    service.task_resource_list
    rest_respond_service service
  end

  private

  def task_resource_params
    params.permit(:start_date, :deadline)
  end

  def resource_params
    params.permit(:id, :name, :description, :resource_type_id, :model_on_type, :model_on_id)
  end
end
