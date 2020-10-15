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

    def get_role_json_view
      { role: @role_group.as_json(only: [:name], include: {
                                                 product_group_permission:    { only: [:id, :show_data, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                 product_type_permission:     { only: [:id, :show_data, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                 product_import_permission:   { only: [:id, :show_data, :import] },
                                                 product_catalog_permission:  { only: [:id, :show_data, :read_data, :create_data, :edit_data, :set_price_data, :delete_record] },
                                                 suppliers_permission:        { only: [:id, :show_data, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                 company_permission:          { only: [:id, :show_data, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                 system_data_permission:      { only: [:id, :show_data, :read_data, :create_data, :edit_data, :activate_data, :delete_record] },
                                                 role_management_permission:  { only: [:id, :show_data, :read_data, :create_data, :edit_data, :activate_data, :delete_record]}
                                                  })}
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

    def get_role
      find_role
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
      @role_group = RoleGroup.find_by_id(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @role_group
    end
  end
end