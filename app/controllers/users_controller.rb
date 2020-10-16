class UsersController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def current_user
    service = Account::CurrentUserService.new(current_account)
    service.current_user
    rest_respond_service service
  end

  def list
    service = Account::UsersService.new(users_params)
    service.users_list
    rest_respond_service service
  end

  #we don't need it yet
  #def manage
  #  service = Account::UsersService.new(users_params)
  #  service.manage_user
  #  rest_respond_service service
  #end

  private

  def users_params
    params.permit(:id)
  end
end
