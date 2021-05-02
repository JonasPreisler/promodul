module Tasks
  class Services
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params, account, company)
      @params = params
      @errors = []
      @current_company = company
      @current_user = account
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
      validate_dates
      validate_project_dates
      validate_users
      validate_resources
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
      tasks = Task.joins(project: [user_account: :company]).where(companies: {id: @current_company.id})
      tasks = tasks.where(user_accounts: {id: @current_user.id}) if project_manager?
      @builded_object = []

      tasks.all.each do |task|
        @builded_object << build_object(task)
      end
    end

    def project_manager?
      @current_user.user_role.role_group.id_name.eql?("project_manager")
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
          resources: get_resources(task),
          project_id: task.project.id
      }
    end

    def get_users(task)
      UserAccount
          .select('user_accounts.id, first_name, last_name, user_account_tasks.id as task_user_id')
          .joins(user_account_tasks: :task)
          .where(tasks: {id: task.id })
          .group('user_accounts.id, user_account_tasks.id').as_json
    end

    def get_resources(task)
      Resource.select('resources.id, name, task_resources.id as task_resource_id').joins(task_resources: :task).where(tasks: {id: task.id }).group('resources.id, task_resources.id').as_json
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
      ActiveRecord::Base.transaction do
        user_tasks = UserAccountTask.where(task_id: @task.id)
        resource_tasks = TaskResource.where(task_id: @task.id)
        user_tasks.delete_all if user_tasks
        resource_tasks.delete_all if resource_tasks
        @task.destroy
      end

      @errors << fill_errors(@task) if @task.errors.any?
    end

    private

    def validate_users
      return if errors.any?
      return if params["user_account_tasks_attributes"].nil?
      params["user_account_tasks_attributes"].each do |x|
        user_dates = get_user_dates(x["user_account_id"])
        user_dates.reject! { |record| record["start_time"].nil? }
        user_dates.each do |date|
          if period.overlaps?(date["start_time"].to_datetime..date["deadline"].to_datetime)
            fill_custom_errors(self, :base,:invalid, "Employee #{date["first_name"] + " " + date["last_name"]} is busy on this dates")
          end
        end
      end
    end

    def validate_resources
      return if errors.any?
      return if params["task_resources_attributes"].nil?
      params["task_resources_attributes"].each do |x|
        resource_dates = get_resource_dates(x["resource_id"])
        resource_dates.reject! { |record| record["start_time"].nil? }
        resource_dates.each do |date|
          if period.overlaps?(date["start_time"].to_datetime..date["deadline"].to_datetime)
            fill_custom_errors(self, :base,:invalid, "Resource #{date["name"]} is busy on this dates")
          end
        end
      end
    end

    def get_resource_dates(data)
      Resource
          .select("name, tasks.start_time, tasks.deadline")
          .joins("LEFT JOIN task_resources ON task_resources.resource_id = resources.id")
          .joins("LEFT JOIN tasks ON tasks.id = task_resources.task_id")
          .where(resources: { id: data })
          .as_json
    end

    def period
      @params["start_time"].to_datetime..@params["deadline"].to_datetime
    end

    def employee

    end

    def get_user_dates(user)
      UserAccount
          .select("first_name, last_name, tasks.start_time, tasks.deadline")
          .joins("LEFT JOIN user_account_tasks ON user_account_tasks.user_account_id = user_accounts.id")
          .joins("LEFT JOIN tasks ON tasks.id = user_account_tasks.task_id")
          .where(user_accounts: { id: user })
          .as_json
    end

    def validate_project_dates
      return if errors.any?
      @project = Project.find(@params[:project_id])
      if params[:start_time].to_datetime < @project.start_date
        fill_custom_errors(self, :base,:invalid, "The task start date can't be less Project's date")
      end
      return if errors.any?
      if params[:deadline].to_datetime > @project.deadline
        fill_custom_errors(self, :base,:invalid, "The task deadline date can't be greater then Project's date")
      end
    end

    def validate_dates
      if params[:start_time].to_datetime < DateTime.now.beginning_of_day
        fill_custom_errors(self, :base,:invalid, "The task start date can't be less than today")
      end
      return if errors.any?
      if params[:start_time].to_datetime > params[:deadline].to_datetime
        fill_custom_errors(self, :base,:invalid, "The deadline should be greater than the start date")
      end
    end

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