module Settings
  class CountryAndCityService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
    end

    def country_json_view
      { country: @country.as_json }
    end

    def city_json_view
      { city: @city.as_json }
    end

    def countries_json_view
      { countries: @countries.as_json }
    end

    def cities_json_view
      { cities: @cities.as_json }
    end

    def country
      @country = Country.where(country_code: params[:country_code]).first_or_initialize
      @country.update(name: params[:name])
      errors.concat(@country.errors.to_a) if @country.errors.any?
    end

    def city
      @city = City.where(city_code: params[:city_code]).first_or_initialize
      @city.update(name: params[:name], country_id: params[:country_id])
      errors.concat(@city.errors.to_a) if @city.errors.any?
    end

    def countries
      @countries = Country.all
    end

    def cities
      @cities = City.where(country_id: params[:country_id])
    end
  end
end