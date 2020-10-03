class ProductPricesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Products::ProductPriceService.new(product_price_params)
    service.call
    rest_respond_service service
  end

  def price
    service = Products::ProductPriceService.new(product_price_params)
    service.price
    rest_respond_service service
  end

  private

  def product_price_params
    params.permit(:id, :product_id, :list_price_type, :list_price_amount, :manufacturing_cost)
  end
end
