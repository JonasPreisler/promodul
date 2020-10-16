class RoleGroupsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = Roles::RoleManagementService.new(role_params)
    service.create_role
    rest_respond_service service
  end

  def list
    service = Roles::RoleManagementService.new(role_params)
    service.list
    rest_respond_service service
  end

  def get_role
    service = Roles::RoleManagementService.new(role_params)
    service.get_role
    rest_respond_service service
  end

  def update
    service = Roles::RoleManagementService.new(role_params)
    service.update
    rest_respond_service service
  end

  def destroy
    service = Roles::RoleManagementService.new(role_params)
    service.destroy
    rest_respond_service service
  end

  private

  def role_params
    params.permit(:id, :name,
                  product_group_permission_attributes:   {},
                  product_type_permission_attributes:    {},
                  product_import_permission_attributes:  {},
                  product_catalog_permission_attributes: {},
                  suppliers_permission_attributes:       {},
                  company_permission_attributes:         {},
                  system_data_permission_attributes:     {},
                  role_management_permission_attributes: {})
  end
end
