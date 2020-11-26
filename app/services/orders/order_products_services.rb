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
      { order_product: @order_product.as_json(include: { product: { only: [:name, :code, :full_name] } }, only: [:count]) }
    end

    def product_order_list_json_view
      { products: @products.as_json(only: [:id, :name, :full_name, :code]) }
    end

    #def destroy_json_view
    #  { success: true }
    #end

    #def show_json_view
    #  { order: @order.as_json(include: {  client: {only: [:name]  },
    #                                      order_status: { only: [:name] },
    #                                      order_type: { only: [:name] },
    #                                      user_account: { only: [:username] } },
    #                          only: [:id, :start_time, :title, :description, :created_at]) }
    #end

    def order_products_list_json_view
      { products: @order_products.as_json(include: { product: { only: [:name, :code, :full_name] } }, only: [:count]) }
    end

    def create_order_product
      validate_data!
      create_order_product_obj
    end

    def product_list
      @products = Product.where(active: true)
    end

    def order_products_list
      @order_products = OrderProduct.where(order_id: params[:id])
    end

    #def update_client
    #  validate_data!
    #  update_client_obj
    #end

    def show
      find_order
    end

    #def delete_client
    #  find_client
    #  return if @errors.any?
    #  @client.active = false
    #  @client.save
    #  @errors << fill_errors(@client) if @client.errors.any?
    #end

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

    def create_order_product_obj
      return if errors.any?
      @order_product = OrderProduct.new(params)
      @order_product.save
      @errors << fill_errors(@order_product) if @order_product.errors.any?
    end

    def default_status
      @status = OrderStatus.find_by(id_name: :open)
    end
    #
    #def update_client_obj
    #  find_client
    #  @client.update(params)
    #  @errors << fill_errors(@client) if @client.errors.any?
    #end

    def find_order
      @order = Order.find_by_id(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @order
    end
  end
end