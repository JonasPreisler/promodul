class SettingsController < ApplicationController
  require 'controller_response'
  include ControllerResponse

  #ToDO: Need remove after authorization will works
  skip_before_action :validate_authentication

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

  private

  def country_params
    params.permit(:id, :name, :country_code)
  end

  def city_params
    params.permit(:id, :name, :city_code, :country_id)
  end
end
