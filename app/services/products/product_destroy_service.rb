module Products
  class ProductDestroyService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors


    def initialize(product_params)
      @product_params = product_params
      @errors = []
    end

    def destroy_json_view
      { success: true }
    end

    def destroy_product
      @product = Product.find(@product_params[:id])
      @product.destroy
      @errors << fill_errors(@product) if @product.errors.any?
    end

  end
end