module Owners
  class Dashboard
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(account)
      @errors = []
      @current_user = account
    end

    def json_view
      { companies: @companies, projects: @projects, tasks: @tasks, resources: @resources, users: @users }
    end

    def call
      @companies = companies
      @projects = projects_stats
      @tasks = tasks_stats
      @users = users_stats
      @resources = resource_stats
    end

    private

    def companies
      {
          active_companies: get_companies(true),
          not_active_companies: get_companies(false),
          total: get_companies(true) + get_companies(false)
      }
    end

    def get_companies(type)
      Company.where(active: type).count
    end

    def users_stats
      {
          project_manager: get_user("project_manager"),
          employee: get_user("employee"),
          admin: get_user("super_admin"),
          total: user_total(["project_manager", "employee", "super_admin"])
      }
    end

    def get_user(role)
      UserAccount.joins(user_role: :role_group).where(role_groups: { id_name: role}, active: true).count
    end

    def user_total(roles)
      UserAccount.joins(user_role: :role_group).where(role_groups: { id_name: roles}, active: true).count
    end

    def resource_stats
      {
          machine: get_resource("machine"),
          tool: get_resource("tool"),
          external: get_resource("external_resource"),
          total: total_resources
      }
    end

    def get_resource(type)
      Resource.joins(:resource_type).where(resource_types: { id_name: type}).count
    end

    def total_resources
      Resource.count
    end

    def tasks_stats
      {
          done: get_tasks("done"),
          in_progress: get_tasks("in_progress"),
          open: get_tasks("open"),
          total: total_tasks
      }
    end

    def projects_stats
      {
          finished: get_finished,
          current: get_current,
          scheduled: get_scheduled,
          total: total
      }
    end

    def get_tasks(status)
      Task.joins(:task_status, project: :user_account).where(task_statuses: { id_name: status}).count
    end

    def total_tasks
      Task.joins(:task_status, project: :user_account).count
    end

    def get_finished
      Project.joins(:user_account).where('deadline < ?', DateTime.now).count
    end

    def get_current
      Project.joins(:user_account).where('start_date < ? AND deadline > ?', DateTime.now, DateTime.now).count
    end

    def get_scheduled
      Project.joins(:user_account).where('start_date > ?', DateTime.now).count
    end

    def total
      Project.joins(:user_account).count
    end
  end
end