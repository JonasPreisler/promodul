module Products
  class ProductUpdateService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors


    def initialize(product_params)
      @product_params = product_params
      @errors = []
    end

    def update_json_view
      { product: @product.as_json(include: {
          product_characteristic: {
              only: [:shape, :volume, :packaging, :manufacturer, :description,
                     :external_code, :sales_start, :sales_end, :EAN_code, :weight,
                     :width, :height, :depth]
          }
      }) }
    end

    def update_product
      @product = Product.find(@product_params[:id])
      @product.update(@product_params.as_json(except: :id))
      @errors << fill_errors(@product) if @product.errors.any?
    end

  end
end