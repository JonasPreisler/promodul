module Suppliers
  class SupplierProductsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(supplier_product_params)
      @supplier_product_params = supplier_product_params
      @errors = []
    end

    def create_supplier_product
      validate_data!
      create_item
    end

    def update_supplier_product
      find_supplier_product
      @supplier_product.update(@supplier_product_params.as_json(except: :id))
      @errors << fill_errors(@supplier_product) if @supplier_product.errors.any?
    end

    def edit_supplier_product
      find_supplier_product
    end

    def destroy_supplier_product
      find_supplier_product
      @supplier_product.destroy
      @errors << fill_errors(@supplier_product) if @supplier_product.errors.any?
    end

    private

    def find_supplier_product
      @supplier_product = SupplierProduct.find_by_id(@supplier_product_params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless supplier
    end

    def validate_data!
      validate_supplier!
      validate_product!
    end

    def create_item
      return if errors.any?
      binding.pry
      @supplier_product = SupplierProduct.new(@supplier_product_params)
      @supplier_product.save
      @errors << fill_errors(@supplier_product) if @supplier_product.errors.any?
    end

    def validate_supplier!
      supplier = Supplier.find_by_id(@supplier_product_params[:supplier_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless supplier
    end

    def validate_product!
      product = Product.find_by_id(@supplier_product_params[:product_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless product
    end
  end
end