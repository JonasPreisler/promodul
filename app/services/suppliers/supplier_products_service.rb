module Suppliers
  class SupplierProductsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(supplier_product_params)
      @supplier_product_params = supplier_product_params
      @errors = []
    end

    def json_view
      { success: true }
    end

    def update_json_view
      { supplier_product: @supplier_product.as_json(include: {
                                                    product: { only: [:name, :description, :instruction] },
                                                    supplier_product_price: { only: [:supplier_product_id, :price, :currency_id],
                                                                              include: { currency: { only: [:id, :name, :code, :symbol] } } } }) }
    end

    def list_json_view
      { supplier_products: @supplier_products.as_json(include: {
          product: { only: [:name, :description, :instruction] },
          supplier_product_price: { only: [:supplier_product_id, :price, :currency_id],
                                    include: { currency: { only: [:id, :name, :code, :symbol] } } } }) }
    end

    def create_supplier_product
      validate_data!
      ActiveRecord::Base.transaction do
        create_item
        create_price
        raise ActiveRecord::Rollback if errors.any?
      end
    end

    def update_supplier_product
      find_supplier_product
      @supplier_product.update(@supplier_product_params)
      @errors << fill_errors(@supplier_product) if @supplier_product.errors.any?
    end

    def edit_supplier_product
      find_supplier_product
    end

    def destroy_supplier_product
      find_supplier_product
      @supplier_product.is_active = true
      @supplier_product.save
      @errors << fill_errors(@supplier_product) if @supplier_product.errors.any?
    end

    def supplier_product_list
      @supplier_products = SupplierProduct.where(supplier_id: @supplier_product_params[:supplier_id],  is_active: true)
    end

    private

    def find_supplier_product
      @supplier_product = SupplierProduct.find_by_id(@supplier_product_params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @supplier_product
    end

    def validate_data!
      validate_supplier!
      validate_product!
    end

    def create_item
      return if errors.any?
      @supplier_product = SupplierProduct.new
      @supplier_product.supplier_id = @supplier_product_params[:supplier_id]
      @supplier_product.product_id = @supplier_product_params[:product_id]
      @supplier_product.supplier_code = @supplier_product_params[:supplier_code]
      @supplier_product.quantity = @supplier_product_params[:quantity]
      @supplier_product.save
      @errors << fill_errors(@supplier_product) if @supplier_product.errors.any?
    end

    def create_price
      return if errors.any?
      @supplier_prod_price = SupplierProductPrice.new(@supplier_product_params[:supplier_product_price_attributes])
      @supplier_prod_price.supplier_product_id = @supplier_product.id
      @supplier_prod_price.save
      @errors << fill_errors(@supplier_prod_price) if @supplier_prod_price.errors.any?
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