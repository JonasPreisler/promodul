class SettingsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  #skip_before_action :validate_authentication
  #before_action :is_super_admin?

  def machine_model
    service = Settings::ModelsService.new(current_account,models_params)
    service.machine_model
    rest_respond_service service
  end

  def tool_model
    service = Settings::ModelsService.new(current_account,models_params)
    service.tool_model
    rest_respond_service service
  end

  def external_source_type
    service = Settings::ModelsService.new(current_account,models_params)
    service.source_type
    rest_respond_service service
  end

  def destroy_machine_model
    service = Settings::ModelsService.new(current_account,models_params)
    service.destroy_machine_model
    rest_respond_service service
  end

  def destroy_tool_model
    service = Settings::ModelsService.new(current_account,models_params)
    service.destroy_tool_model
    rest_respond_service service
  end

  def destroy_external_source_type
    service = Settings::ModelsService.new(current_account,models_params)
    service.destroy_external_source_type
    rest_respond_service service
  end

  def machine_models
    service = Settings::ModelsService.new(current_account,models_params)
    service.machine_models
    rest_respond_service service
  end

  def external_source_types
    service = Settings::ModelsService.new(current_account,models_params)
    service.source_types
    rest_respond_service service
  end

  def tool_models
    service = Settings::ModelsService.new(current_account,models_params)
    service.tool_models
    rest_respond_service service
  end

  def country
    service = Settings::CountryAndCityService.new(country_params)
    service.country
    rest_respond_service service
  end

  def city
    service = Settings::CountryAndCityService.new(city_params)
    service.city
    rest_respond_service service
  end

  def countries
    service = Settings::CountryAndCityService.new(country_params)
    service.countries
    rest_respond_service service
  end

  def cities
    service = Settings::CountryAndCityService.new(city_params)
    service.cities
    rest_respond_service service
  end

  def destroy_country
    service = Settings::CountryAndCityService.new(country_params)
    service.destroy_country
    rest_respond_service service
  end

  def destroy_city
    service = Settings::CountryAndCityService.new(city_params)
    service.destroy_city
    rest_respond_service service
  end

  private

  def country_params
    params.permit(:id, :name, :country_code)
  end

  def city_params
    params.permit(:id, :name, :city_code, :country_id)
  end

  def models_params
    params.permit(:id, :name)
  end
end
