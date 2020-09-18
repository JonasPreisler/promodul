class CategoriesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDo: Need remove after authorization will works
  #skip_before_action :validate_authentication

  def create
    service = CategorySubCategories::CategoriesService.new(category_params)
    service.create_category
    rest_respond_service service
  end

  def update
    service = CategorySubCategories::CategoriesService.new(category_params)
    service.update_category
    rest_respond_service service
  end

  def destroy
    service = CategorySubCategories::CategoriesService.new(destroy_params)
    service.destroy
    rest_respond_service service
  end

  def list
    service = CategorySubCategories::CategoriesService.new(destroy_params)
    service.category_list
    rest_respond_service service
  end

  private

  def category_params
    params[:category].permit(:id, :id_name, :active, name: {})
  end

  def destroy_params
    params.permit(:id)
  end
end
