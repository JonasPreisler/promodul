class SchedulersController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def view
    service = Scheduler::Services.new(current_account)
    service.call
    rest_respond_service service
  end
end
