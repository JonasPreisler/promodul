module Owners
  class CompanyServices
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(params)
      @errors = []
      @params = params
    end

    def json_view
      { companies: @companies.as_json(only: [:id, :name, :address, :phone_number, :active]) }
    end

    def stop_license_json_view
      { success: true }
    end

    def activate_license_json_view
      { success: true }
    end

    def company_list
      @companies = Company.all
    end

    def deactivate_company
      find_company
      return if @errors.any?
      @company.active = false
      @company.save

      @errors << fill_errors(@company) if @company.errors.any?
    end

    def activate_company
      find_company
      return if @errors.any?
      @company.active = true
      @company.save

      @errors << fill_errors(@company) if @company.errors.any?
    end

    private

    def find_company
      @company = Company.find_by_id(@params[:company_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @company
    end

  end
end