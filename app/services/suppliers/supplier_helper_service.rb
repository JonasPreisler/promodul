module Suppliers
  class SupplierHelperService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :token , :errors


    def initialize()
      @errors = []
    end

    def business_types_json_view
      { business_types: @business_type.as_json }
    end

    def integration_systems_json_view
      { integrations_systems: @integration_systems.as_json }
    end

    def business_types
      @business_type = BusinessType.all
    end

    def integrations_systems
      @integration_systems = IntegrationSystem.all
    end

  end
end