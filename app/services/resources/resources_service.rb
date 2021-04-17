module Resources
  class ResourcesService
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

    def destroy_json_view
      { success: true }
    end

    def resource_list_json_view
      { resources: @list.as_json() }
    end

    def resource_type_list_json_view
      { types: @type_list.as_json() }
    end

    def resource_calendar_json_view
      { dates: @dates.as_json }
    end

    def create_resource
      validate_data!
      create_resource_obj
    end

    def resource_list
      @list =
              {
                  machines: get_models,
                  tools: get_tools,
                  external_resources: get_external_resources
              }
    end

    def resource_type_list
      @type_list = ResourceType.all
    end

    def get_models
      Resource
          .select('resources.id, resources.name, description, machine_models.name as mod_name')
          .joins(:resource_type).joins('INNER JOIN machine_models on machine_models.id = resources.model_on_id')
          .where(model_on_type: "MachineModel", resource_types: { id_name: "machine"})
          .as_json
    end

    def get_tools
      Resource
          .select('resources.id, resources.name, description, tool_models.name as tool_name')
          .joins(:resource_type).joins('INNER JOIN tool_models on tool_models.id = resources.model_on_id')
          .where(model_on_type: "ToolModel", resource_types: { id_name: "tool"})
          .as_json
    end

    def get_external_resources
      Resource
          .select('resources.id, resources.name, description, external_resource_types.name as external_name')
          .joins(:resource_type)
          .joins('INNER JOIN external_resource_types on external_resource_types.id = resources.model_on_id')
          .where(model_on_type: "ExternalResourceType", resource_types: { id_name: "external_resource"})
          .as_json
    end

    def update_resource
      validate_data!
      update_resource_obj
    end

    def destroy
      find_resource
      return if @errors.any?
      @resource.delete
      @resource.save
      @errors << fill_errors(@resource) if @resource.errors.any?
    end

    def resource_calendar
      @dates = Resource
                   .select('projects.id, tasks.id as task_id, tasks.title as task_title, task_status.id_name as task_status,
                            tasks.start_time as start, tasks.deadline as end, projects.title')
                   .joins(task_resources: [task: [:task_status, :project]])
                   .where(id: @params[:id])
    end

    private

    def validate_data!
      validate_resource_type
    end

    def validate_resource_type
      resource_type = ResourceType.find_by_id(params[:resource_type_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless resource_type
    end

    def create_resource_obj
      return if errors.any?
      @resource = Resource.new(params)
      @resource.save
      @errors << fill_errors(@resource) if @resource.errors.any?
    end

    def update_resource_obj
      find_resource
      @resource.update(params)
      @errors << fill_errors(@resource) if @resource.errors.any?
    end

    def find_resource
      @resource = Resource.find_by_id(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @resource
    end

  end
end