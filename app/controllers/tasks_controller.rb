class TasksController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Tasks::Services.new(task_params, current_account, current_company)
    service.create_task
    rest_respond_service service
  end

  def tasks_list
    service = Tasks::Services.new(task_params, current_account, current_company)
    service.task_list
    rest_respond_service service
  end

  def user_task_list
    service = Tasks::Services.new(task_params, current_account, current_company)
    service.user_task_list
    rest_respond_service service
  end

  def show
    service = Tasks::Services.new(progress_params, current_account, current_company)
    service.show
    rest_respond_service service
  end


  def status_progress
    service = Tasks::Services.new(progress_params, current_account, current_company)
    service.progress
    rest_respond_service service
  end

  def update
    service = Tasks::Services.new(task_params, current_account, current_company)
    service.update_task
    rest_respond_service service
  end

  def destroy
    service = Tasks::Services.new(task_params, current_account, current_company)
    service.delete_task
    rest_respond_service service
  end

  private

  def task_params
    params.permit(:id, :title, :description, :project_id, :start_time, :deadline, user_account_tasks_attributes: [:id, :user_account_id, :_destroy], task_resources_attributes: [:id, :resource_id, :_destroy])
  end

  def progress_params
    params.permit(:id, :id_name)
  end
end