class ProductsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  def create
    service = Products::ProductCreateService.new(product_params)
    service.create_product
    rest_respond_service service
  end

  def update
    service = Products::ProductUpdateService.new(product_params)
    service.update_product
    rest_respond_service service
  end

  def destroy
    service = Products::ProductDestroyService.new(product_params)
    service.destroy_product
    rest_respond_service service
  end

  def list
    service = Products::ProductListService.new(product_params)
    service.list
    rest_respond_service service
  end


  private

  def product_params
    params.permit(:id, :description, :code, name: {}, full_name: {}, product_characteristic_attributes: {} )
  end
end
