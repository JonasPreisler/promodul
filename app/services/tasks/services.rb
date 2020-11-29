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

    def destroy_json_view
      { success: true }
    end

    def show_json_view
      { task: @task.as_json(include: {  task_status: { only: [:name] },
                                        user_account: { only: [:username] },
                                        product: { only: [:name] } },
                              only: [:id, :title, :description, :start_time, :deadline, :tracked_time, :created_at]) }
    end

    def tasks_list_json_view
      { tasks: @tasks.as_json(include: {  task_status: { only: [:name] },
                                          user_account: { only: [:username] } },
                              only: [:id, :start_time, :deadline, :title, :description]) }
    end

    def create_task
      validate_data!
      default_status
      create_task_obj
    end

    def task_list
      @tasks = Task.where(order_id: params[:id])
    end

    def progress
      find_status
      find_task
      return if errors.any?
      @task.update(task_status_id: @status.id)
      @errors << fill_errors(@task) if @task.errors.any?
    end

    def update_task
      find_task
      update_task_obj
    end

    def show
      find_task
    end

    def delete_task
      find_task
      return if @errors.any?
      @task.destroy
      @errors << fill_errors(@task) if @task.errors.any?
    end

    private

    def find_status
      @status = TaskStatus.find_by(id_name: params[:id_name])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @status
    end

    def find_task
      return if errors.any?
      @task = Task.find(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @task
    end

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

    def update_task_obj
      @task.update(params)
      @errors << fill_errors(@task) if @task.errors.any?
    end
  end
end