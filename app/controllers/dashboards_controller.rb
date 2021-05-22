class DashboardsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def view
    service = Dashboard::Services.new(current_account)
    service.call
    rest_respond_service service
  end

  private

end
