class OrdersController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Orders::OrdersServices.new(orders_params)
    service.create_order
    rest_respond_service service
  end

  def order_type
    service = Orders::OrdersServices.new(orders_params)
    service.get_types
    rest_respond_service service
  end

  def orders_list
    service = Orders::OrdersServices.new(orders_params)
    service.order_list
    rest_respond_service service
  end

  def open_orders_list
    service = Orders::OrdersServices.new(orders_params)
    service.open_order_list
    rest_respond_service service
  end

  def my_orders_list
    service = Orders::OrdersServices.new(orders_params)
    service.my_order_list
    rest_respond_service service
  end

  def show
    service = Orders::OrdersServices.new(orders_params)
    service.admin_order_list
    rest_respond_service service
  end

  def overview
    service = Orders::OrdersServices.new(orders_params)
    service.overview
    rest_respond_service service
  end

  def claim_order
    service = Orders::OrdersServices.new(claim_params)
    service.claim_order
    rest_respond_service service
  end

  def all_orders_list
    service = Orders::OrdersServices.new(orders_params)
    service.admin_order_list
    rest_respond_service service
  end

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

  def orders_params
    params.permit(:id, :title, :description, :client_id, :user_account_id, :order_type_id, :start_time, :deadline, :type)
  end

  def claim_params
    params.permit(:order_id, :user_account_id)
  end
end
