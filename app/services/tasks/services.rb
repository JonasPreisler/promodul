module Tasks
  class Services
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { task: @task.as_json(include: {  task_status: { only: [:name] },
                                        user_account: { only: [:username] } },
                              only: [:id, :start_time, :deadline, :title, :description]) }
    end

    #def order_type_json_view
    #  { types: @types.as_json }
    #end

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
    #
    #def orders_list_json_view
    #  { orders: @orders.as_json(include: {  client: {only: [:name]  },
    #                                        order_status: { only: [:name] },
    #                                        order_type: { only: [:name] },
    #                                        user_account: { only: [:username] } },
    #                            only: [:id, :start_time, :title]) }
    #end

    def create_task
      validate_data!
      default_status
      create_task_obj
    end

    #def get_types
    #  @types = OrderType.all
    #end
    #
    #def order_list
    #  @orders = Order.all
    #end

    #def update_client
    #  validate_data!
    #  update_client_obj
    #end

    #def show
    #  find_order
    #end

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
      validate_user_account
      validate_product
    end

    def validate_order
      @order = Order.find_by(id: params[:order_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @order
    end


    def validate_user_account
      return if errors.any?
      user_account = UserAccount.find_by_id(params[:user_account_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless user_account
    end

    def validate_product
      return if errors.any?
      product = Product.find_by_id(params[:product_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless product
    end

    def create_task_obj
      return if errors.any?
      @task = Task.new(params)
      @task.task_status_id = @status&.id
      @task.save
      @errors << fill_errors(@task) if @task.errors.any?
    end

    def default_status
      @status = TaskStatus.find_by(id_name: :open)
    end
    #
    ##def update_client_obj
    ##  find_client
    ##  @client.update(params)
    ##  @errors << fill_errors(@client) if @client.errors.any?
    ##end
    #
    #def find_order
    #  @order = Order.find_by_id(params[:id])
    #  fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @order
    #end
  end
end