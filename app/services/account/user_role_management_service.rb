module Account
  class UserRoleManagementService
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

    def initialize_role
      validate_user!
      validate_role!
      create_user_role
    end

    def destroy_user_role
      find_user_role
      validate_destroy!
      destroy
    end

    private

    def find_user_role
      @user_role = UserRole.find(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @user_role
    end

    def validate_destroy!
      if UserRole.where(user_account_id: @user_role.user_account_id).count < 2
        fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.user_role"))
      end
    end

    def destroy
      return if errors.any?
      @user_role.destroy
      @errors << fill_errors(@user_role) if @user_role.errors.any?
    end

    def validate_user!
      return if errors.any?
      @user = UserAccount.find(params[:user_account_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @user
    end

    def validate_role!
      return if errors.any?
      @role_group = RoleGroup.find_by_id_name(params[:id_name])
      fill_custom_errors(self, :base, :invalid, I18n.t("custom.errors.validation.business_customer")) unless @user
    end

    def create_user_role
      return if errors.any?
      @user_role = UserRole.where(user_account_id: @user.id).first_or_initialize
      @user_role.role_group_id =  @role_group.id
      @user_role.save
      @errors << fill_errors(@user_role) if @user_role.errors.any?
    end
  end
end