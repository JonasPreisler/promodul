class RoleGroupsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Roles::RoleManagementService.new(role_params)
    service.create_role
    rest_respond_service service
  end

  private

  def role_params
    params.permit(:id, :name,
                  product_group_permission_attributes:   {},
                  product_type_permission_attributes:    {},
                  product_import_permission_attributes:  {},
                  product_catalog_permission_attributes: {})
  end
end
