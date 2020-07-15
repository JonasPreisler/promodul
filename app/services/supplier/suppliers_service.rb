module Supplier
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
      { supplier: @supplier.as_json }
    end

    def destroy_json_view
      { supplier: @supplier.as_json }
    end

    def list_json_view
      { suppliers: @supplier.as_json(except: :id) }
    end


    def create_supplier
      @supplier = Supplier.new(@supplier_params)
      @supplier.active = true

      @errors.concat(fill_errors(@supplier))
    end

    def update_supplier
      @supplier = Supplier.find(@supplier_params[:id])
      @supplier.update(@supplier_params.except(:id))

      @errors.concat(fill_errors(@supplier))
    end

    def destroy_supplier
      @supplier = Supplier.find(@supplier_params[:id])
      @supplier.active = false
      @errors.concat(fill_errors(@supplier))
    end

    def list
      @supplier = Supplier.where(active: true)
    end
  end
end