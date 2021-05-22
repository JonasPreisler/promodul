class AttachmentsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = Resources::AttachmentsService.new(current_account, file_params)
    service.create_file
    rest_respond_service service
  end

  def show_file
    service = Resources::AttachmentsService.new(current_account, file_params)
    file = service.read_file
    if file&.exists?
      send_data(file.read, filename: file.filename, content_type: file.content_type, disposition: 'inline')
    else
      render json: { errors: service.errors }, status: 400
    end
  end

  def get_files
    service = Resources::AttachmentsService.new(current_account, file_params)
    service.files
    rest_respond_service service
  end
  #
  #def destroy
  #  #ToDo: Ask to Roy if we need that Role here
  #  #return unless check_permission(['superadmin', 'admin'])
  #  service = Products::ProductImageService.new(image_params)
  #  service.delete_picture
  #  rest_respond_service service
  #end

  private

  def file_params
    params.permit(:attached_on_id, :attached_on_type, :file, :exp_date, :uuid, :model_on_type, :model_on_id)
  end
end
