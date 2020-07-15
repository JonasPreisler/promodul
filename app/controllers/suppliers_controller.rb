class SuppliersController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #Create Supplier
  def create
    service = Supplier::SuppliersService.new(supplier_params)
    service.create_supplier
    rest_respond_service service
  end

  #Update Supplier
  def update
    service = Supplier::SuppliersService.new(supplier_params)
    service.update_supplier
    rest_respond_service service
  end

  #Update Supplier
  def destroy
    service = Supplier::SuppliersService.new(supplier_params)
    service.destroy_supplier
    rest_respond_service service
  end

  #Update Supplier
  def list
    service = Supplier::SuppliersService.new(supplier_params)
    service.list
    rest_respond_service service
  end


  private

  def supplier_params
    params.permit(:id, :integration_system_id, :business_type_id, :identification_code, :name, :phone_number)
  end
end
