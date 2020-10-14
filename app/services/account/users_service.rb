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

    def users_list
      @users = Customer
                   .select("user_accounts.id, customers.name, user_accounts.active, user_accounts.phone_number,  user_roles.id as user_role_id,
                            user_accounts.email, user_accounts.username, user_roles.role_group_id, role_groups.name as role_name")
                   .joins(user_account: [user_roles: :role_group])
    end

    private


  end
end