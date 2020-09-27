class SupplierProductsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = Supplier::SupplierProductsService.new(supplier_product_params)
    service.create_supplier_product
    rest_respond_service service
  end

  def update
    service = Supplier::SupplierProductsService.new(supplier_product_params)
    service.update_supplier_product
    rest_respond_service service
  end

  def edit_product
    service = Supplier::SupplierProductsService.new(supplier_product_params)
    service.edit_supplier_product
    rest_respond_service service
  end

  def destroy
    service = Supplier::SupplierProductsService.new(supplier_product_params)
    service.destroy_supplier_product
    rest_respond_service service
  end

  private

  def supplier_product_params
    params.permit(:supplier_id, :product_id, :supplier_code, :quantity, supplier_product_price_attributes: {})
  end
end
