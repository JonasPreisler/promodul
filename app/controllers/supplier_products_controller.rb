class SupplierProductsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = Suppliers::SupplierProductsService.new(supplier_product_params)
    service.create_supplier_product
    rest_respond_service service
  end

  def update
    service = Suppliers::SupplierProductsService.new(supplier_product_params)
    service.update_supplier_product
    rest_respond_service service
  end

  def edit_product
    service = Suppliers::SupplierProductsService.new(supplier_product_params)
    service.edit_supplier_product
    rest_respond_service service
  end

  def destroy
    service = Suppliers::SupplierProductsService.new(supplier_product_params)
    service.destroy_supplier_product
    rest_respond_service service
  end

  private

  def supplier_product_params
    params.permit(:id, :supplier_id, :product_id, :is_active, :supplier_code, :quantity, supplier_product_price_attributes: {})
  end
end
