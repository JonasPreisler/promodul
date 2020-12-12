module Orders
  class OrderProductsServices
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { order_product: @order_product.as_json(include: { product: { only: [:name, :code, :full_name] } }, only: [:id, :count]) }
    end

    def product_order_list_json_view
      { products: @products.as_json(only: [:id, :name, :full_name, :code]) }
    end

    def destroy_json_view
      { success: true }
    end

    def order_products_list_json_view
      { products: @order_products.as_json(include: { product: { only: [:name, :code, :full_name] } }, only: [:id, :count]) }
    end

    def create_order_product
      params.each do |obj|
        create_order_product_obj(obj)
      end
      @order_product = OrderProduct.where(order_id: params.first[:order_id])
    end

    def product_list
      @products = Product.where(active: true)
    end

    def order_products_list
      @order_products = OrderProduct.where(order_id: params[:id])
    end

    def update_order_prod
      update_order_product
    end

    def show
      find_order_product
    end

    def delete_order_prod
      find_order_product
      return if @errors.any?
      @order_product.destroy
      @errors << fill_errors(@order_product) if @order_product.errors.any?
    end

    private

    def validate_data!
      validate_order
      validate_product
    end

    def validate_product
      product = Product.find_by(id: params[:product_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless product
    end

    def validate_order
      order = Order.find_by(id: params[:order_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless order
    end

    def create_order_product_obj(obj)
      return if errors.any?
      @order_product = OrderProduct.new
      @order_product.order_id = obj[:order_id]
      @order_product.product_id = obj[:product_id]
      @order_product.count = obj[:count]
      @order_product.save
      @errors << fill_errors(@order_product) if @order_product.errors.any?
    end

    def default_status
      @status = OrderStatus.find_by(id_name: :open)
    end

    def update_order_product
      find_order_product
      @order_product.update(params)
      @errors << fill_errors(@order_product) if @order_product.errors.any?
    end

    def find_order_product
      @order_product = OrderProduct.find_by_id(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @order_product
    end
  end
end