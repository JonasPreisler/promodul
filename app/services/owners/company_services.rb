module Owners
  class CompanyServices
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(account)
      @errors = []
      @current_user = account
    end

    def json_view
      { companies: @companies.as_json(only: [:id, :name, :address, :phone_number, :active]) }
    end

    def company_list
      @companies = Company.all
    end

  end
end