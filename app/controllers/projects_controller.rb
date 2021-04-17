class ProjectsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Projects::ProjectsServices.new(project_params, current_account)
    service.create_project
    rest_respond_service service
  end

  def projects_list
    service = Projects::ProjectsServices.new(project_params, nil)
    service.projects_list
    rest_respond_service service
  end

  def show
    service = Projects::ProjectsServices.new(project_params, nil)
    service.overview
    rest_respond_service service
  end

  def project_calendar
    service = Projects::ProjectsServices.new(project_params, nil)
    service.project_calendar
    rest_respond_service service
  end

  def update
    service = Projects::ProjectsServices.new(project_params, current_account)
    service.update_project
    rest_respond_service service
  end

  def destroy
    service = Projects::ProjectsServices.new(project_params, current_account)
    service.delete_project
    rest_respond_service service
  end

  private

  def project_params
    params.permit(:id, :title, :description, :address, :post_number, :contact_person, :start_date, :deadline)
  end

  #def claim_params
  #  params.permit(:order_id, :user_account_id)
  #end
end
