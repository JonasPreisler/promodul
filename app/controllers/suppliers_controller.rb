class SuppliersController < ApplicationController
  require 'controller_response'
  include ControllerResponse


  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication


  #Create Supplier
  def create
    service = Suppliers::SuppliersService.new(supplier_params)
    service.create_supplier
    rest_respond_service service
  end

  #Update Supplier
  def update
    service = Suppliers::SuppliersService.new(supplier_params)
    service.update_supplier
    rest_respond_service service
  end

  #Update Supplier
  def destroy
    service = Suppliers::SuppliersService.new(supplier_params)
    service.destroy_supplier
    rest_respond_service service
  end

  #Update Supplier
  def list
    service = Suppliers::SuppliersService.new(supplier_params)
    service.list
    rest_respond_service service
  end

  #Business_types
  def business_types
    service = Suppliers::SupplierHelperService.new()
    service.business_types
    rest_respond_service service
  end

  #Integrations_systems
  def integration_systems
    service = Suppliers::SupplierHelperService.new()
    service.integrations_systems
    rest_respond_service service
  end


  private

  def supplier_params
    params.permit(:id, :integration_system_id, :business_type_id, :identification_code, :name, :phone_number, :active)
  end
end
