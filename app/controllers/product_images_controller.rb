class ProductImagesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = Products::ProductImageService.new(image_params)
    service.create_product_image
    rest_respond_service service
  end

  def show_image
    service = Products::ProductImageService.new(image_params)
    file = service.read_image

    if file&.exists?
      send_data(file.read, filename: file.filename, content_type: file.content_type, disposition: 'inline')
    else
      render json: { errors: service.errors }, status: 400
    end
  end

  def destroy
    #ToDo: Ask to Roy if we need that Role here
    #return unless check_permission(['superadmin', 'admin'])
    service = Products::ProductImageService.new(image_params)
    service.delete_picture
    rest_respond_service service
  end

  private

  def image_params
    params.permit(:id, :product_id, :image, :uuid)
  end
end
