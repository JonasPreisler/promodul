module General
  class CurrenciesService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { currencies: @currencies.as_json }
    end

    def list
      @currencies = Currency.all
    end
  end
end