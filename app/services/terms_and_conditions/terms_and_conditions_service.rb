module TermsAndConditions
  class TermsAndConditionsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { terms_and_conditions: @terms.as_json  }
    end

    def create
      @terms = TermsAndCondition.new(@params)
      @terms.save

      @errors << fill_errors(@terms) if @terms.errors.any?
    end

    def list
      @terms = TermsAndCondition.all
    end
  end
end