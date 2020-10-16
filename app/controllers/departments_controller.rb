class DepartmentsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = Companies::DepartmentsService.new(department_params)
    service.create_department
    rest_respond_service service
  end

  def update
    service = Companies::DepartmentsService.new(department_params)
    service.update_department
    rest_respond_service service
  end

  def destroy
    service = Companies::DepartmentsService.new(department_params)
    service.destroy
    rest_respond_service service
  end

  def department_list
    service = Companies::DepartmentsService.new(department_params)
    service.department_list
    rest_respond_service service
  end

  def sub_department_list
    service = Companies::DepartmentsService.new(department_params)
    service.sub_department_list
    rest_respond_service service
  end

  private

  def department_params
    params.permit(:id, :name, :description, :address, :phone_number, :country_id, :city_id, :parent_id, :company_id)
  end
end
