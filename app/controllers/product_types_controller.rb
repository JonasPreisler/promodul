class ProductTypesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = Products::ProductTypeService.new(product_type_params)
    service.create
    rest_respond_service service
  end

  def update
    service = Products::ProductTypeService.new(product_type_params)
    service.update
    rest_respond_service service
  end

  def destroy
    service = Products::ProductTypeService.new(product_type_params)
    service.destroy
    rest_respond_service service
  end

  def list
    service = Products::ProductTypeService.new(product_type_params)
    service.list
    rest_respond_service service
  end

  private

  def product_type_params
    params.permit(:id, :active, name: {})
  end
end
