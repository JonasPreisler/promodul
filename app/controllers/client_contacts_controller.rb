class ClientContactsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Clients::ContactsService.new(clients_params)
    service.create_contact
    rest_respond_service service
  end

  def contacts_list
    service = Clients::ContactsService.new(clients_params)
    service.contact_list
    rest_respond_service service
  end

  def show
    service = Clients::ContactsService.new(clients_params)
    service.show
    rest_respond_service service
  end

  def update
    service = Clients::ContactsService.new(clients_params)
    service.update_client
    rest_respond_service service
  end

  def destroy
    service = Clients::ContactsService.new(clients_params)
    service.delete_client
    rest_respond_service service
  end

  private

  def clients_params
    params.permit(:id, :first_name, :last_name, :email, :phone, :client_id, :position)
  end
end
