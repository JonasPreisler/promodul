module Products
  class ProductCreateService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors


    def initialize(product_params)
      @product_params = product_params
      @errors = []
    end

    def json_view
      { product: @product.as_json(include: { product_characteristic: { only: [:shape, :volume, :packaging, :manufacturer, :description]}}) }
    end

    def create_product
      @product = Product.new(@product_params)
      @product.save
      @errors << fill_errors(@product) if @product.errors.any?
    end

  end
end