module Account
  class CurrentUserService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :current_user

    def initialize(current_user)
      @errors = []
      @current_user = current_user
    end

    def json_view

      { current_user:  @user.as_json(only: [:id, :phone_number, :email, :username, :first_name, :last_name], include:
                                 { user_role:
                                       { only: [:id], include:
                                           { role_group:  { only: [:name]
                                             }
                                           }
                                       }
                                 }) }
    end

    def current_user
      @user = @current_user
    end
  end
end