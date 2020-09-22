module Suppliers
  class SuppliersService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :token , :errors


    def initialize(supplier_params)
      @supplier_params = supplier_params
      @errors = []
    end

    def create_json_view
      { supplier: @supplier.as_json }
    end

    def update_json_view
      { supplier: @supplier.as_json(except: [:integration_system_id, :business_type_id, :active]) }
    end

    def destroy_json_view
      { supplier: @supplier.as_json(only: [:id, :active]) }
    end

    def list_json_view
      { suppliers:  @supplier.as_json(include: { integration_system: { only: [:name]}}, except: [:business_type_id]) }
    end


    def create_supplier
      @supplier = Supplier.new(@supplier_params)
      @supplier.active = true
      @supplier.save

      @errors.concat(fill_errors(@supplier))
    end

    def update_supplier
      @supplier = Supplier.find(@supplier_params[:id])
      @supplier.update(@supplier_params.except(:id))

      @errors.concat(fill_errors(@supplier))
    end

    def destroy_supplier
      @supplier = Supplier.find(@supplier_params[:id])
      @supplier.destroy
      @errors.concat(fill_errors(@supplier))
    end

    def list
      @supplier = Supplier.all
    end
  end
end