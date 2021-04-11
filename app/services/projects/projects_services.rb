module Projects
  class ProjectsServices
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params, current_user)
      @params = params
      @errors = []
      @current_user = current_user
    end

    def json_view
      { project: @project.as_json(include: { user_account: { only: [:first_name, :last_name]}}) }
    end

    def show_json_view
      { project: @project.as_json(include: { user_account: { only: [:first_name, :last_name]}}), members: @members }
    end

    def projects_list_json_view
      { projects: @projects.as_json(include: { user_account: { only: [:first_name, :last_name]}}) }
    end

    def my_orders_list_json_view
      { orders: @orders.as_json(include: {  client: {only: [:name]  },
                                            order_status: { only: [:name] },
                                            order_type: { only: [:name] },
                                            user_account: { only: [:username] } },
                                only: [:id, :start_time, :title]) }
    end


    def create_project
      @project = Project.new(@params)
      @project.user_account_id = @current_user.id
      @project.project_id = generate_id
      @project.save
      @project << fill_errors(@project) if @project.errors.any?
    end

    def generate_id
      unic_id = ""
      if Project.last&.id.present?
        number = 5 - Project.last&.id&.to_s&.size.to_i
        number.times { unic_id += "0"}
        unic_id += (Project.last&.id.to_i + 1).to_s
      else
        unic_id = "00001"
      end
      unic_id
    end

    def projects_list
      @projects = Project.all
    end

    def overview
      @project = Project.find_by_id(@params[:id])
      get_members
    end

    def get_members
      @members = UserAccount
                    .select("user_accounts.id, first_name, last_name, 'employ' AS status")
                    .joins(user_account_tasks: [task: :project])
                    .where(projects: { id: @project.id })
                    .group('user_accounts.id')
                    .as_json
      @members << {
          id: @project.user_account.id,
          first_name: @project.user_account.first_name,
          last_name: @project.user_account.last_name,
          status: "manager"
      }
    end

    #def open_order_list
    #  @orders = Order
    #                .select("id, title as name, TO_CHAR(start_time, 'yyyy-mm-dd hh:mm') as start, TO_CHAR(start_time + (3 * interval '20 minute'), 'yyyy-mm-dd hh:mm') as end")
    #                .where(order_status_id: 1, user_account_id: nil )
    #end
    #
    #def admin_order_list
    #  @orders = Order
    #                .select("orders.id,
    #                         title as name,
    #                         TO_CHAR(start_time, 'yyyy-mm-dd hh:mm') as start,
    #                         TO_CHAR(start_time + (3 * interval '20 minute'), 'yyyy-mm-dd hh:mm') as end,
    #                         order_statuses.name AS status,
    #                         user_accounts.username AS employ")
    #                .joins(:order_status, :user_account)
    #end
    #
    #def my_order_list
    #  @orders = Order.where(user_account_id: params[:user_account_id])
    #end
    #
    #def claim_order
    #  status_id = OrderStatus.find_by_id_name(:claimed).id
    #  @order = Order.find(params[:order_id])
    #  @order.update(user_account_id: params[:user_account_id], order_status_id: status_id)
    #  @errors << fill_errors(@order) if @order.errors.any?
    #end
    #
    #def overview
    #end
    #
    #def overview_json
    #  {
    #      order_title: get_order,
    #      percentage_of_tasks: percentage_of_tasks,
    #      worked_hours: worked_hours,
    #      order_price: order_price,
    #      order_members: order_members,
    #  }
    #end

    #def show
    #  find_order
    #end

    private

    #def get_order
    #  Order.find(params[:id]).title
    #end
    #
    #def order_members
    #  order_ids = Order.select(:user_account_id).where(id: params[:id]).pluck(:user_account_id)
    #  tasks_ids = Task.select(:user_account_id).where(order_id: params[:id]).pluck(:product_id)
    #  users = order_ids.union(tasks_ids)
    #  UserAccount.select('username, email, phone_number').where(id: users).as_json()
    #end
    #
    #def order_price
    #  order_price = 0
    #  order_ids = OrderProduct.select(:product_id).where(order_id: params[:id]).pluck(:product_id)
    #  tasks_ids = Task.select(:product_id).where(order_id: params[:id]).pluck(:product_id)
    #  product_ids = order_ids + tasks_ids
    #  ProductPrice.where(product_id: product_ids).each do |x|
    #    kk = SupplierProduct.find_by_product_id(x.product_id)&.supplier_product_price&.price&.to_i
    #    if kk
    #      cost_price = x.list_price_amount&.to_i + kk
    #    else
    #      cost_price = x.list_price_amount&.to_i
    #    end
    #    if x.list_price_type.eql?("fix_price")
    #      order_price += cost_price + x.list_price_amount&.to_d
    #    else
    #      order_price += ((cost_price*(100 + x.list_price_amount.to_d))/100).ceil(2)
    #    end
    #  end
    #  order_price
    #end
    #
    #def worked_hours
    #  sum = 0
    #  Task.where(order_id: params[:id]).each do |x|
    #    time = x&.tracked_time.to_i
    #    sum += time
    #  end
    #  sum
    #end
    #
    #def percentage_of_tasks
    #  {
    #      open: Task.where(order_id: params[:id], task_status_id: 1).size,
    #      in_progress: Task.where(order_id: params[:id], task_status_id: 2).size,
    #      done: Task.where(order_id: params[:id], task_status_id: 3).size,
    #      total: Task.where(order_id: params[:id]).size
    #  }
    #end

    #def validate_client
    #  @client = Client.where(id: params[:client_id], active: true).last
    #  fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @client
    #end
    #
    #
    #def validate_user_account
    #  return if errors.any?
    #  user_account = UserAccount.find_by_id(params[:user_account_id])
    #  fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless user_account
    #end
    #
    #def validate_order_type
    #  return if errors.any?
    #  type = OrderType.find_by_id(params[:order_type_id])
    #  fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless type
    #end
    #
    #def create_order_obj
    #  return if errors.any?
    #  @order = Order.new(params)
    #  @order.order_status_id = @status&.id
    #  @order.save
    #  @errors << fill_errors(@order) if @order.errors.any?
    #end
    #
    #def default_status
    #  @status = OrderStatus.find_by(id_name: :open)
    #end
    ##
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