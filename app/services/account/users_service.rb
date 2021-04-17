module Account
  class UsersService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
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

    def users_list
      @users = Customer
                   .select("user_accounts.id, customers.name, user_accounts.active, user_accounts.phone_number,
                            user_accounts.email, user_accounts.username, user_accounts.first_name, user_accounts.last_name")
                   .joins(:user_account)
                   .where(user_accounts: { active: true})

        #ToDo: Change query when we add roles.
      #@users = Customer
      #             .select("user_accounts.id, customers.name, user_accounts.active, user_accounts.phone_number,  user_roles.id as user_role_id,
      #                      user_accounts.email, user_accounts.username, user_roles.role_group_id, role_groups.name as role_name")
      #             .joins(user_account: [user_role: :role_group])
      #             .where(user_accounts: { active: true})
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
      @dates = UserAccount
                   .select('projects.id, tasks.id as task_id, tasks.title as task_title, task_status.id_name as task_status
                            tasks.start_time as start, tasks.deadline as end, projects.title')
                   .joins(user_account_tasks: [task: [:task_status, :project]])
                   .where(id: @params[:id])
                   .as_json
    end

    private

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
      @user = UserAccount.find_by_id(params[:id])
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