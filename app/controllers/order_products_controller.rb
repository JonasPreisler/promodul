class OrderProductsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Orders::OrderProductsServices.new(params["_json"])
    service.create_order_product
    rest_respond_service service
  end

  def product_order_list
    service = Orders::OrderProductsServices.new(product_params)
    service.product_list
    rest_respond_service service
  end

  def order_products_list
    service = Orders::OrderProductsServices.new(order_product_params)
    service.order_products_list
    rest_respond_service service
  end

  def show
    service = Orders::OrderProductsServices.new(order_product_params)
    service.show
    rest_respond_service service
  end

  def update
    service = Orders::OrderProductsServices.new(order_product_params)
    service.update_order_prod
    rest_respond_service service
  end

  def destroy
    service = Orders::OrderProductsServices.new(order_product_params)
    service.delete_order_prod
    rest_respond_service service
  end

  private

  def order_product_params
    params.permit(:id, :order_id, :product_id, :count)
  end

  def product_params
    params.permit({})
  end

  def bulk_order_products
    params.permit(_json:[])
  end
end
