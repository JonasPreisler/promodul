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

    def create_role
      @role_group = RoleGroup.new(@params)
      @role_group.id_name = @params[:name].downcase.parameterize(separator: '_')
      @role_group.save
      @errors << fill_errors(@role_group) if @role_group.errors.any?
    end
  end
end