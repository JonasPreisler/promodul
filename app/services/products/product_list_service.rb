module Products
  class ProductListService
    require 'errors_format'
    require 'product_helper'
    include ErrorsFormat
    include ProductHelper

    attr_reader :errors


    def initialize(product_params)
      @product_params = product_params
      @errors = []
    end

    def list_json_view
      { product: @product.as_json(include: product_characteristics_schema) }
    end

    def product_type_json_view
      { product_types: @product_types.as_json }
    end

    def product_vat_type_json_view
      { product_vat_types: @product_vat_types.as_json }
    end

    def list
      @product = Product.all
    end

    def product_types
      @product_types = ProductType.all
    end

    def product_vat_types
      @product_vat_types = ProductVatType.all
    end

  end
end