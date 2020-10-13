module Roles
  class RoleManagementService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { role: @role_group.as_json() }
    end

    def list_json_view
      { roles: @role_group.as_json(only: [:id, :name, :updated_at]) }
    end

    def create_role
      @role_group = RoleGroup.new(@params)
      @role_group.id_name = @params[:name].downcase.parameterize(separator: '_')
      @role_group.save
      @errors << fill_errors(@role_group) if @role_group.errors.any?
    end

    def list
      @role_group = RoleGroup.all
    end

    def update
      find_role
      return if errors.any?
      @role_group.assign_attributes(params)
      @role_group.save

      @errors << fill_errors(@role_group) if @role_group.errors.any?
    end

    def destroy
      find_role
      validate_destroy!
      destroy_role_group
    end

    private

    def validate_destroy!
      return if errors.any?
      if UserRole.where(role_group_id: @role_group.id).present?
        fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.role_group"))
      end
    end

    def destroy_role_group
      return if errors.any?
      @role_group.destroy
      @errors << fill_errors(@role_group) if @role_group.errors.any?
    end

    def find_role
      @role_group = RoleGroup.find(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @role_group
    end
  end
end