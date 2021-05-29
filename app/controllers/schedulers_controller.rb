class SchedulersController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def view
    service = Scheduler::Services.new(current_account, type_param)
    service.call
    rest_respond_service service
  end

  def type_param
    params.permit(:type)
  end
end
