class UsersController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

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
