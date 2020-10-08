class CompaniesController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

  def create
    service = Companies::CompaniesService.new(company_params)
    service.create_company
    rest_respond_service service
  end

  def update
    #service = CategorySubCategories::SubCategoriesService.new(sub_category_params)
    #service.update_sub_category
    #rest_respond_service service
  end

  def destroy
    #service = CategorySubCategories::SubCategoriesService.new(destroy_params)
    #service.destroy
    #rest_respond_service service
  end

  def list
    #service = CategorySubCategories::SubCategoriesService.new(list_paranms)
    #service.sub_category_list
    #rest_respond_service service
  end

  private

  def company_params
    params.permit(:id, :name, :description, :address, :phone_number, :country_id, :city_id, :parent_id)
  end
end
