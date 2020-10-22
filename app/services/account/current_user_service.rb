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

      { current_user:  @user.as_json(only: [:phone_number, :email, :username], include:
                                 { user_role:
                                       { only: [:id], include:
                                           { role_group: { only: [:name], include:
                                               {
                                                   product_group_permission: { only: [:no_access, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                   product_type_permission: { only: [:no_access, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                   product_import_permission: { only: [:no_access, :import] },
                                                   product_catalog_permission: { only: [:no_access, :read_data, :create_data, :edit_data, :delete_record, :set_price_data] },
                                                   suppliers_permission: { only: [:no_access, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                   system_data_permission: { only: [:no_access, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                   company_permission: { only: [:no_access, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                   role_management_permission: { only: [:no_access, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                   user_management_permission: { only: [:no_access, :read_data, :manage_data, :activate_data] }

                                               }
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