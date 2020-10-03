module Products
  class ProductPriceService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :price_params

    def initialize(price_params)
      @price_params = price_params
      @errors = []
    end

    def call
      validate_product
      first_or_initialize_price
      calculation
    end

    def price
      find_product_prices
      calculation
    end

    def json_view
      { price_data: @price_data }
    end

    private

      def find_product_prices
        @product_price = ProductPrice.find_by(product_id: price_params[:product_id])
        fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @product_price
      end

      def validate_product
        product = Product.find(price_params[:product_id])
        fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless product
      end

      def first_or_initialize_price
        @product_price = ProductPrice.where(product_id: price_params[:product_id]).first_or_initialize
        @product_price.update(list_price_type: price_params[:list_price_type],
                              list_price_amount: price_params[:list_price_amount],
                              manufacturing_cost: price_params[:manufacturing_cost])
        errors.concat(@product_price.errors.to_a) if @product_price.errors.any?
      end

      def calculation
        @supplier_product = SupplierProduct.where(product_id: @product_price.product_id)
        @price_data = []
        if @supplier_product.present?
          @supplier_product.each do |supplier_product|
            @price_data << set_prices(supplier_product)
          end
        else
          @price_data << set_prices
        end
        @price_data
      end

    def set_prices(supplier_product = nil)
      cost_price = @product_price.manufacturing_cost.to_d + supplier_product&.supplier_product_price&.price.to_d
      {
          supplier: Supplier.find_by_id(supplier_product&.supplier_id)&.name,
          manufacturing_cost: @product_price.manufacturing_cost.to_d,
          purchase_price: supplier_product&.supplier_product_price&.price&.to_d,
          cost_price: cost_price,
          list_price: @product_price.list_price_type.eql?("fix_price") ? cost_price + @product_price.list_price_amount.to_d :
                          ((cost_price*(100 + @product_price.list_price_amount.to_d))/100).ceil(2),
      }
    end
  end
end