class UserRolesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Account::UserRoleManagementService.new(user_role_params)
    service.initialize_role
    rest_respond_service service
  end

  #By default user should have at least one role
  def destroy
    service = Account::UserRoleManagementService.new(user_role_params)
    service.destroy_user_role
    rest_respond_service service
  end

  private

  def user_role_params
    params.permit(:id, :user_account_id, :role_group_id)
  end
end
