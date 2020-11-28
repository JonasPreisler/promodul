class TasksController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Tasks::Services.new(task_params)
    service.create_task
    rest_respond_service service
  end

  #def order_type
  #  service = Orders::OrdersServices.new(orders_params)
  #  service.get_types
  #  rest_respond_service service
  #end

  def tasks_list
    service = Tasks::Services.new(task_params)
    service.task_list
    rest_respond_service service
  end

  def status_progress
    service = Tasks::Services.new(progress_params)
    service.progress
    rest_respond_service service
  end

  #
  #def show
  #  service = Orders::OrdersServices.new(orders_params)
  #  service.show
  #  rest_respond_service service
  #end

  #def update
  #  service = Clients::Service.new(clients_params)
  #  service.update_client
  #  rest_respond_service service
  #end
  #
  #def destroy
  #  service = Clients::Service.new(clients_params)
  #  service.delete_client
  #  rest_respond_service service
  #end

  private

  def task_params
    params.permit(:id, :title, :description, :order_id, :user_account_id, :product_id, :start_time, :deadline)
  end

  def progress_params
    params.permit(:id, :id_name)
  end
end