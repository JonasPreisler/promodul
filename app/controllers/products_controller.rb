class ProductsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Products::ProductCreateService.new(create_params)
    service.create_product
    rest_respond_service service
  end


  private

  def create_params
    params.permit(:description, :code, name: {}, full_name: {}, product_characteristic_attributes: {} )
  end
end
