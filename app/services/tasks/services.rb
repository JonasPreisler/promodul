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
      { success: true }
    end

    def destroy_json_view
      { success: true }
    end

    def show_json_view
      { task: @task.as_json }
    end

    def tasks_list_json_view
      { tasks: @builded_object }
    end

    def user_task_list_json_view
      { tasks: @builded_object }
    end

    def status_progress_json_view
      { task: @task.as_json }
    end

    def create_task
      #validate_data!
      default_status
      create_task_obj
    end

    def task_list
      @builded_object = []
      Task.where(project_id: params["id"]).each do |task|
        @builded_object << build_object(task)
      end
    end

    def user_task_list
      @builded_object = []
      #After Roles here we will ad if else statment for fifferent role, Admin, manager, employ
      Task.all.each do |task|
        @builded_object << build_object(task)
      end
    end

    def build_object(task)
      {
          id: task.id,
          title: task.title,
          description: task.description,
          status:  task.task_status.id_name,
          start_time: task.start_time,
          deadline: task.deadline,
          project_name:  task.project.title,
          users: get_users(task),
          resources: get_resources(task)
      }
    end

    def get_users(task)
      UserAccount
          .select('user_accounts.id, first_name, last_name')
          .joins(user_account_tasks: :task)
          .where(tasks: {id: task.id })
          .group('user_accounts.id').as_json
    end

    def get_resources(task)
      Resource.select('resources.id, name').joins(task_resources: :task).where(tasks: {id: task.id }).group('resources.id').as_json
    end

    def progress
      find_status
      find_task
      return if errors.any?
      @task.update(task_status_id: @status.id)
      @task = build_object(@task)
    end

    def update_task
      find_task
      update_task_obj
    end

    def show
      find_task
      return if errors.any?
      @task = build_object(@task)
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
      validate_dates
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