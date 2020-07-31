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
      { products: @product.as_json(include: { product_characteristic: { only: [:shape, :volume, :packaging, :manufacturer, :description]}}) }
    end

    def list
      @product = Product.all
    end

  end
end