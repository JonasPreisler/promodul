class CompaniesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = Companies::CompaniesService.new(company_params)
    service.create_company
    rest_respond_service service
  end

  def company_admin
    registration = Account::RegistrationService.new(current_company, admin_params)
    registration.call
    rest_respond_service registration
  end

  def update
    service = Companies::CompaniesService.new(company_params)
    service.update_company
    rest_respond_service service
  end

  def destroy
    service = Companies::CompaniesService.new(company_params)
    service.destroy
    rest_respond_service service
  end

  def show
    service = Companies::CompaniesService.new(company_params)
    service.show
    rest_respond_service service
  end

  def company_list
    service = Companies::CompaniesService.new(company_params)
    service.company_list
    rest_respond_service service
  end

  def sub_company_list
    service = Companies::CompaniesService.new(company_params)
    service.sub_company_list
    rest_respond_service service
  end

  private

  def current_company
    Company.find_by_id(params[:company_id])
  end

  def admin_params
    params.permit(  :phone_number,
                    :phone_number_iso,
                    :email,
                    :password,
                    :password_confirmation,
                    :agreed_terms_and_conditions,
                    :terms_and_conditions_id,
                    :first_name,
                    :last_name,
                    :username,
                    :delivery_address,
                    :invoice_address,
                    :customer_type)
  end

  def company_params
    params.permit(:id, :name, :description, :phone_number, :address, :country_id, :city_id, :parent_id, :legal_entity)
  end
end
