class ProductsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  def search
    service = Products::EsSearchService.new(product_search_params, current_customer)
    service.search_a_product
    rest_respond_service service
  end

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

  def product_type
    service = Products::ProductListService.new(product_params)
    service.product_types
    rest_respond_service service
  end

  def product_vat_type
    service = Products::ProductListService.new(product_params)
    service.product_vat_types
    rest_respond_service service
  end

  def import_products
    service = Products::ImportProductsService.new(nil, params)
    service.create_and_call

    rest_respond_service service
  end

  private

  def product_params
    params.permit(:id, :description, :instruction, :code, name: {}, full_name: {}, product_characteristic_attributes: {} )
  end

  def product_search_params

  end

  def product_type_params
    params.permit(:id, :active, name: {})
  end
end
