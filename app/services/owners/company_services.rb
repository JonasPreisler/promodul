module Owners
  class CompanyServices
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(params)
      @errors = []
      @params = params
    end

    def json_view
      { companies: @companies.as_json(only: [:id, :name, :address, :phone_number, :active]) }
    end

    def stop_license_json_view
      { success: true }
    end

    def activate_license_json_view
      { success: true }
    end

    def company_stats_json_view
      { projects: @projects, tasks: @tasks, resources: @resources, users: @users }
    end

    def company_list
      @companies = Company.all
    end

    def deactivate_company
      find_company
      return if @errors.any?
      @company.active = false
      @company.save

      @errors << fill_errors(@company) if @company.errors.any?
    end

    def activate_company
      find_company
      return if @errors.any?
      @company.active = true
      @company.save

      @errors << fill_errors(@company) if @company.errors.any?
    end

    def stats
      @projects = projects_stats
      @tasks = tasks_stats
      @users = users_stats
      @resources = resource_stats
    end

    private

    def users_stats
      {
          project_manager: get_user("project_manager"),
          employee: get_user("employee"),
          admin: get_user("super_admin"),
          total: user_total(["project_manager", "employee", "super_admin"])
      }
    end

    def get_user(role)
      UserAccount.joins(user_role: :role_group).where(role_groups: { id_name: role}, company_id: @params[:company_id], active: true).count
    end

    def user_total(roles)
      UserAccount.joins(user_role: :role_group).where(role_groups: { id_name: roles}, company_id:  @params[:company_id], active: true).count
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
      Resource.joins(:resource_type).where(resource_types: { id_name: type}, company_id:  @params[:company_id]).count
    end

    def total_resources
      Resource.where(company_id:  @params[:company_id]).count
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
      Task.joins(:task_status, project: :user_account).where(user_accounts: { company_id:  @params[:company_id]}, task_statuses: { id_name: status}).count
    end

    def total_tasks
      Task.joins(:task_status, project: :user_account).where(user_accounts: { company_id:  @params[:company_id]}).count
    end

    def get_finished
      Project.joins(:user_account).where(user_accounts: { company_id:  @params[:company_id]}).where('deadline < ?', DateTime.now).count
    end

    def get_current
      Project.joins(:user_account).where(user_accounts: { company_id:  @params[:company_id]}).where('start_date < ? AND deadline > ?', DateTime.now, DateTime.now).count
    end

    def get_scheduled
      Project.joins(:user_account).where(user_accounts: { company_id:  @params[:company_id]}).where('start_date > ?', DateTime.now).count
    end

    def total
      Project.joins(:user_account).where(user_accounts: { company_id:  @params[:company_id]}).count
    end

    def find_company
      @company = Company.find_by_id(@params[:company_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @company
    end

  end
end