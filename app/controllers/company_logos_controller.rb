class CompanyLogosController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Companies::CompanyLogoService.new(logo_params)
    service.create_company_logo
    rest_respond_service service
  end

  def show_logo
    service = Companies::CompanyLogoService.new(logo_params)
    file = service.read_logo

    if file&.exists?
      send_data(file.read, filename: file.filename, content_type: file.content_type, disposition: 'inline')
    else
      render json: { errors: service.errors }, status: 400
    end
  end

  def destroy
    service = Companies::CompanyLogoService.new(logo_params)
    service.delete_logo
    rest_respond_service service
  end

  private

  def logo_params
    params.permit(:id, :company_id, :logo, :uuid)
  end
end
