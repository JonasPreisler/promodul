class OrderCommentsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Orders::CommentsService.new(comment_params)
    service.create_comment
    rest_respond_service service
  end

  def comments_list
    service = Orders::CommentsService.new(comment_params)
    service.list
    rest_respond_service service
  end

  private

  def comment_params
    params.permit(:id, :order_id, :user_account_id, :comment)
  end
end
