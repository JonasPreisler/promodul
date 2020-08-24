module Products
  class ProductListService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors


    def initialize(product_params)
      @product_params = product_params
      @errors = []
    end

    def list_json_view
      { product: @product.as_json(include: {
          product_characteristic: {
              only: [:shape, :volume, :packaging, :manufacturer, :description,
                     :external_code, :sales_start, :sales_end, :EAN_code, :weight,
                     :width, :height, :depth]
          }
      }) }
    end

    def list
      @product = Product.all
    end

  end
end