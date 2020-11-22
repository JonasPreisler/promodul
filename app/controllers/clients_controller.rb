class ClientsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Clients::Service.new(clients_params)
    service.create_client
    rest_respond_service service
  end

  def client_type
    service = Clients::Service.new(clients_params)
    service.get_types
    rest_respond_service service
  end

  def client_group
    service = Clients::Service.new(clients_params)
    service.get_groups
    rest_respond_service service
  end

  def clients_list
    service = Clients::Service.new(clients_params)
    service.client_list
    rest_respond_service service
  end

  def show
    service = Clients::Service.new(clients_params)
    service.show
    rest_respond_service service
  end

  def update
    service = Clients::Service.new(clients_params)
    service.update_client
    rest_respond_service service
  end

  def destroy
    service = Clients::Service.new(clients_params)
    service.delete_client
    rest_respond_service service
  end

  private

  def clients_params
    params.permit(:id, :name, :address, :vat_number, :active, :phone_number, :country_id, :city_id, :user_account_id,
                  :phone, :web_address, :kunde_nr, :currency_id, :clients_group_id, :clients_type_id)
  end

end
