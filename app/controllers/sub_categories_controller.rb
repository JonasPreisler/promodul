class SubCategoriesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = CategorySubCategories::SubCategoriesService.new(sub_category_params)
    service.create_sub_category
    rest_respond_service service
  end

  def update
    service = CategorySubCategories::SubCategoriesService.new(sub_category_params)
    service.update_sub_category
    rest_respond_service service
  end

  def destroy
    service = CategorySubCategories::SubCategoriesService.new(destroy_params)
    service.destroy
    rest_respond_service service
  end

  def list
    service = CategorySubCategories::SubCategoriesService.new(list_paranms)
    service.sub_category_list
    rest_respond_service service
  end

  private

  def sub_category_params
    params[:sub_category].permit(:id, :category_id, :id_name, :active, name: {})
  end

  def destroy_params
    params.permit(:id)
  end

  def list_paranms
    params.permit(:category_id)
  end
end
