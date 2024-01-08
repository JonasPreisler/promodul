module Account
  class UsersService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params, account, company)
      @params = params
      @errors = []
      @current_account = account
      @current_company = company
    end

    def json_view
      { users: @users.as_json() }
    end

    def approve_registration_json_view
      { success: true }
    end

    def listen_to_unconfirmed_users_json_view
      { pending: @pending_users }
    end

    def user_calendar_json_view
      { dates: @dates.as_json }
    end

    def task_user_list_json_view
      { employees: @users.as_json }
    end

    def employee_calendar_json_view
      { dates: @dates.as_json }
    end

    def delete_user_json_view
      { success: true }
    end

    def users_list
      @users = Customer
                   .select("user_accounts.id, customers.name, user_accounts.active, user_accounts.phone_number,
                            user_accounts.email, user_accounts.username, user_accounts.first_name, user_accounts.last_name, role_groups.id_name as user_role")
                   .joins(user_account: [:company, [user_role: :role_group]])
                   .where(user_accounts: { active: true})
                   .where(role_groups: { id_name: id_names})
                   .where(companies: { id: @current_company.id })
                   .as_json
    end

    def id_names
      if @current_account.user_role.role_group.id_name.eql?("super_admin")
        [:project_manager, :employee]
      else
        [:employee]
      end
    end

    def unconfirmed_users_list
      @users = Customer
                   .select("user_accounts.id, customers.name, user_accounts.active, user_accounts.phone_number,
                            user_accounts.email, user_accounts.username")
                   .joins(:user_account)
                   .where(user_accounts: { active: false })
    end

    def listen_to_unconfirmed_users
      @pending_users = Account::ConfirmationStorageService.new.get_users_from_redis&.length
    end

    def approve_user_registration
      validate_data
      approve_registration
    end

    def user_calendar
      @dates = get_calendar_dates
    end

    def employee_calendar
      @dates = get_employee_dates
    end

    def deactivate_user
      @user = UserAccount.find(params[:id])
      @user.active = false
      @user.save
    end

    def get_employee_dates
      UserAccount
          .select("project_id as id, start_time as start, deadline as end, assign_id, title, assign_type, status, addr as address, contact")
          .joins("LEFT JOIN  (#{ get_tasks_employee } UNION #{ get_projects_employee }) obj ON obj.account_id = user_accounts.id")
          .where(id: @current_account.id)
          .as_json
    end

    def get_tasks_employee
      UserAccountTask
          .select("projects.contact_person as contact, projects.address as addr, projects.id as  project_id, user_account_tasks.user_account_id as account_id, tasks.start_time, tasks.deadline, tasks.id as assign_id, projects.title as title, 'Task' as assign_type, task_statuses.id_name as status")
          .joins("LEFT JOIN tasks ON tasks.id = user_account_tasks.task_id")
          .joins("LEFT JOIN task_statuses on task_statuses.id = tasks.task_status_id")
          .joins("LEFT JOIN projects on projects.id = tasks.project_id")
          .to_sql
    end

    def get_projects_employee
      UserAccountProject
          .select("projects.contact_person as contact, projects.address as addr, projects.id as  project_id, user_account_projects.user_account_id as account_id, projects.start_date as start_time, projects.deadline, projects.id as assign_id, projects.title as title, 'Project' as assign_type,
                   project_statuses.id_name as status")
          .joins("LEFT JOIN projects ON projects.id = user_account_projects.project_id")
          .joins("LEFT JOIN project_statuses on project_statuses.id = projects.project_status_id")
          .to_sql
    end

    def get_calendar_dates
      UserAccount
          .select("project_id as id, start_time as start, deadline as end, assign_id, title, assign_type, status")
          .joins("LEFT JOIN  (#{ get_tasks_calendar } UNION #{ get_projects_calendar }) obj ON obj.account_id = user_accounts.id")
          .where(id: @params[:id])
          .as_json
    end

    def get_tasks_calendar
      UserAccountTask
          .select("projects.id as  project_id, user_account_tasks.user_account_id as account_id, tasks.start_time, tasks.deadline, tasks.id as assign_id, projects.title as title, 'Task' as assign_type, task_statuses.id_name as status")
          .joins("LEFT JOIN tasks ON tasks.id = user_account_tasks.task_id")
          .joins("LEFT JOIN task_statuses on task_statuses.id = tasks.task_status_id")
          .joins("LEFT JOIN projects on projects.id = tasks.project_id")
          .to_sql
    end

    def get_projects_calendar
      UserAccountProject
          .select("projects.id as  project_id, user_account_projects.user_account_id as account_id, projects.start_date as start_time, projects.deadline, projects.id as assign_id, projects.title as title, 'Project' as assign_type,
                   project_statuses.id_name as status")
          .joins("LEFT JOIN projects ON projects.id = user_account_projects.project_id")
          .joins("LEFT JOIN project_statuses on project_statuses.id = projects.project_status_id")
          .to_sql
    end

    def task_user_list
      user_list_for_task
      set_dates
    end

    def user_list_for_task
      @users = Customer
                   .select("user_accounts.id, customers.name, user_accounts.active, user_accounts.phone_number,
                            user_accounts.email, user_accounts.username, user_accounts.first_name, user_accounts.last_name, role_groups.id_name as user_role")
                   .joins(user_account: [:company, [user_role: :role_group]])
                   .where(user_accounts: { active: true})
                   .where(role_groups: { id_name: :employee})
                   .where(companies: { id: @current_company.id })
                   .as_json
    end

    private

    def set_dates
      @users.each do |user|
        user.merge!(checked: false)
        user.merge!(available_dates: build_available_dates(get_user_dates(user)))
      end
      @users.reject! { |x| x if x[:available_dates].empty? }
    end

    def build_available_dates(user_dates)
      dates_array = []
      user_dates.reject! { |record| record["start_time"].nil? }
      dates = if user_dates.any?
                calculate_dates(user_dates)
              elsif @params[:start_date].to_datetime == @params[:deadline].to_datetime
                [[@params[:start_date].to_datetime, @params[:deadline].to_datetime]]
              else
                [period.step(1).to_a]
              end

      dates.each do |date|
        dates_array << set_date_obj(date)
      end
      dates_array
    end

    def set_date_obj(date)
      {
          first: date.first,
          last: date.last
      }
    end

    def calculate_dates(user_dates)
      new_period = period.step(1).to_a
      user_dates.each do |date|
        new_period -= (date["start_time"].to_datetime..date["deadline"].to_datetime).step(1).to_a
      end
      new_period.chunk_while { |a,b| a+1.days == b}
    end

    def get_user_dates(user)
      UserAccount
          .select("last_name, starts_at, ends_at")
          .joins("JOIN (#{get_tasks_user}) obj ON obj.account_id = user_accounts.id")
          .where(user_accounts: { id: user["id"] })
          .as_json
    end


    # def get_user_dates(user)
    #   UserAccount
    #       .select("last_name, start_time, deadline")
    #       .joins("JOIN  (#{ get_tasks_user } UNION #{ get_projects_user }) obj ON obj.account_id = user_accounts.id")
    #       .where(user_accounts: { id: user["id"] })
    #       .as_json
    # end

    def get_tasks_user
      UserAccountTask
          .select("user_account_id as account_id, user_account_tasks.starts_at, user_account_tasks.ends_at")
          .to_sql
    end

    def get_projects_user
      UserAccountProject
          .select("user_account_projects.user_account_id as account_id, projects.start_date as start_time, projects.deadline")
          .joins("LEFT JOIN projects ON projects.id = user_account_projects.project_id")
          .to_sql

    end

    def period
      @params[:start_date].to_datetime..@params[:deadline].to_datetime
    end

    def approve_registration
      return if errors.any?
      ActiveRecord::Base.transaction do
        update_user
        create_user_role
        update_redis
        raise ActiveRecord::Rollback if errors.any?
      end
    end

    def update_user
      @user.update_column(:active, true)
    end

    def create_user_role
      @user_role = UserRole.create(user_account_id: @user.id, role_group_id: @role.id)
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @user_role
    end

    def validate_data
      validate_user!
      validate_role!
      #validate_department!
    end

    def validate_user!
      return if errors.any?
      @user = UserAccount.find_by_id(@params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @user
    end

    def validate_role!
      return if errors.any?
      @role = RoleGroup.find_by_id(params[:role_group_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @role
    end

    def update_redis
      return if errors.any?
      user_data = Account::ConfirmationStorageService.new
      pending_users = user_data.get_users_from_redis
      pending_users.reject!{ |obj| (obj.empty? || obj["id"].eql?(@user.id)) }
      user_data.store_user_in_redis(pending_users, false)
    end

    #Remove comment after we add department to user
    #def validate_department!
    #  return if errors.any?
    #  @department = Department.find_by_id(params[:department_id])
    #  fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @department
    #end

  end
end