class ClientsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    binding.pry
    service = Clients::Service.new(clients_params)
    service.create_client
    rest_respond_service service
  end

  #def update
  #  service = Companies::CompaniesService.new(company_params)
  #  service.update_company
  #  rest_respond_service service
  #end
  #
  #def destroy
  #  service = Companies::CompaniesService.new(company_params)
  #  service.destroy
  #  rest_respond_service service
  #end
  #
  #def show
  #  service = Companies::CompaniesService.new(company_params)
  #  service.show
  #  rest_respond_service service
  #end
  #
  #def clients_list
  #  service = Companies::CompaniesService.new(company_params)
  #  service.company_list
  #  rest_respond_service service
  #end
  #
  private

  def clients_params
    params.permit(:id, :name, :address, :vat_number, :active, :phone_number, :country_id, :city_id, :user_account_id,
                  :phone, :web_address, :kunde_nr, :currency_id, :clients_group_id, :clients_type_id)
  end
end
