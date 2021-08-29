module Scheduler
  class Services
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(account, params)
      @errors = []
      @current_user = account
      @params = params
    end

    def json_view
      { user_dates: @users, resource_dates: @resources }
    end

    def call
      user_dates = get_user_dates
      @users  = get_users
      @users.each { |x| x['dates'] = user_dates[x['id'].to_s] }
      if @params[:type].eql?("employee")
        resource_dates = get_resource_dates
        @resources = get_resources
        @resources.each { |x| x['dates'] = resource_dates[x['id'].to_s] }
      end

    end

    private

    def get_users
      UserAccount
          .select('user_accounts.id, first_name, last_name')
          .joins(user_role: :role_group)
          .where(company_id: @current_user.company_id, role_groups: { id_name: @params[:type]})
          .as_json
    end

    def get_user_dates
      UserAccount
          .select("id, start_time as start, deadline as end, assign_id, title, assign_type, status")
          .joins("LEFT JOIN  (#{ get_tasks_user } UNION #{ get_projects_user }) obj ON obj.account_id = user_accounts.id")
          .where(company_id: @current_user.company_id)
          .group_by { |x| x["user"]; x["id"]}
          .as_json
    end

    def get_tasks_user
      UserAccountTask
          .select("user_account_tasks.user_account_id as account_id, tasks.start_time, tasks.deadline, tasks.id as assign_id, projects.title as title, 'Task' as assign_type, task_statuses.id_name as status")
          .joins("LEFT JOIN tasks ON tasks.id = user_account_tasks.task_id")
          .joins("LEFT JOIN task_statuses on task_statuses.id = tasks.task_status_id")
          .joins("LEFT JOIN projects on projects.id = tasks.project_id")
          .to_sql
    end

    def get_projects_user
      UserAccountProject
          .select("user_account_projects.user_account_id as account_id, projects.start_date as start_time, projects.deadline, projects.id as assign_id, projects.title as title, 'Project' as assign_type,
                   project_statuses.id_name as status")
          .joins("LEFT JOIN projects ON projects.id = user_account_projects.project_id")
          .joins("LEFT JOIN project_statuses on project_statuses.id = projects.project_status_id")
          .to_sql
    end

    def get_resources
      Resource.select('id, name').where(company_id: @current_user.company_id).as_json
    end

    def get_resource_dates
      Resource
          .select("id, start_time as start, deadline as end, assign_id, title, assign_type, status")
          .joins("LEFT JOIN  (#{ get_tasks_res } UNION #{ get_projects_res }) obj ON obj.resource_id = resources.id")
          .where(company_id: @current_user.company_id)
          .group_by { |x| x["user"]; x["id"]}
          .as_json
    end

    def get_tasks_res
      TaskResource
          .select("resource_id, tasks.start_time, tasks.deadline, tasks.id as assign_id, projects.title as title, 'Task' as assign_type, task_statuses.id_name as status")
          .joins("LEFT JOIN tasks ON tasks.id = task_resources.task_id")
          .joins("LEFT JOIN task_statuses on task_statuses.id = tasks.task_status_id")
          .joins("LEFT JOIN projects on projects.id = tasks.project_id")
          .to_sql
    end

    def get_projects_res
      ProjectResource
          .select("resource_id, projects.start_date as start_time, projects.deadline, projects.id as assign_id, projects.title as title, 'Project' as assign_type,
                   project_statuses.id_name as status")
          .joins("LEFT JOIN projects ON projects.id = project_resources.project_id")
          .joins("LEFT JOIN project_statuses on project_statuses.id = projects.project_status_id")
          .to_sql
    end
  end
end