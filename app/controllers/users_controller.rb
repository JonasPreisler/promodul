class UsersController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication
  #before_action :is_admin_or_manager?

  def current_user
    service = Account::CurrentUserService.new(current_account)
    service.current_user
    rest_respond_service service
  end

  def list
    service = Account::UsersService.new(users_params, current_account, current_company)
    service.users_list
    rest_respond_service service
  end

  def task_user_list
    service = Account::UsersService.new(task_users, current_account, current_company)
    service.task_user_list
    rest_respond_service service
  end

  def approve_registration
    service = Account::UsersService.new(approve_params, current_account, current_company)
    service.approve_user_registration
    rest_respond_service service
  end

  def unconfirmed_list
    service = Account::UsersService.new(users_params, current_account, current_company)
    service.unconfirmed_users_list
    rest_respond_service service
  end

  def listen_to_unconfirmed_users
    service = Account::UsersService.new(users_params, current_account, current_company)
    service.listen_to_unconfirmed_users
    rest_respond_service service
  end

  def user_calendar
    service = Account::UsersService.new(users_params, current_account, current_company)
    service.user_calendar
    rest_respond_service service
  end

  def employee_calendar
    service = Account::UsersService.new(users_params, current_account, current_company)
    service.employee_calendar
    rest_respond_service service
  end

  def delete_user
    service = Account::UsersService.new(users_params, current_account, current_company)
    service.deactivate_user
    rest_respond_service service
  end

  #we don't need it yet
  #def manage
  #  service = Account::UsersService.new(users_params)
  #  service.manage_user
  #  rest_respond_service service
  #end

  private

  def task_users
    params.permit(:start_date, :deadline)
  end

  def users_params
    params.permit(:id)
  end

  def approve_params
    params.permit(:id, :role_group_id)
  end
end
