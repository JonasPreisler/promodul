module Resources
  class ResourcesService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(current_account, params)
      @current_account =  current_account
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

    def task_resource_list_json_view
      { resources: @list.as_json() }
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
          .where(company_id: @current_account.company_id, model_on_type: "MachineModel", resource_types: { id_name: "machine"})
          .as_json
    end

    def get_tools
      Resource
          .select('resources.id, resources.name, description, tool_models.name as tool_name')
          .joins(:resource_type).joins('INNER JOIN tool_models on tool_models.id = resources.model_on_id')
          .where(company_id: @current_account.company_id, model_on_type: "ToolModel", resource_types: { id_name: "tool"})
          .as_json
    end

    def get_external_resources
      Resource
          .select('resources.id, resources.name, description, external_resource_types.name as external_name')
          .joins(:resource_type)
          .joins('INNER JOIN external_resource_types on external_resource_types.id = resources.model_on_id')
          .where(company_id: @current_account.company_id, model_on_type: "ExternalResourceType", resource_types: { id_name: "external_resource"})
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
                   .select('projects.id, tasks.id as task_id, tasks.title as task_title, task_statuses.id_name as task_status,
                            tasks.start_time as start, tasks.deadline as end, projects.title')
                   .joins(task_resources: [task: [:task_status, :project]])
                   .where(id: @params[:id])
    end

    def task_resource_list
      resource_list
      set_dates
    end

    private

    def set_dates
      @list[:machines].each do |machine|
        machine.merge!(checked: false)
        machine.merge!(available_dates: build_available_dates(get_resource_dates(machine)))
      end
      @list[:tools].each do |tool|
        tool.merge!(checked: false)
        tool.merge!(available_dates: build_available_dates(get_resource_dates(tool)))
      end
      @list[:external_resources].each do |external|
        external.merge!(checked: false)
        external.merge!(available_dates: build_available_dates(get_resource_dates(external)))
      end

      @list[:machines].reject! { |x| x if x[:available_dates].empty? }
      @list[:tools].reject! { |x| x if x[:available_dates].empty? }
      @list[:external_resources].reject! { |x| x if x[:available_dates].empty? }
    end

    def build_available_dates(resource_dates)
      dates_array = []
      resource_dates.reject! { |record| record["start_time"].nil? }
      dates = resource_dates.any? ? calculate_dates(resource_dates) : [period.step(1).to_a]
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

    #def get_resource_dates(data)
    #  Resource
    #      .select("tasks.start_time, tasks.deadline")
    #      .joins("LEFT JOIN task_resources ON task_resources.resource_id = resources.id")
    #      .joins("LEFT JOIN tasks ON tasks.id = task_resources.task_id")
    #      .where(resources: { id: data["id"] })
    #      .as_json
    #end

    def get_resource_dates(data)
      Resource
          .select("start_time, deadline")
          .joins("JOIN  (#{ get_tasks_res } UNION #{ get_projects_res }) obj ON obj.resource_id = resources.id")
          .where(resources: { id: data["id"] })
          .as_json
    end

    def get_tasks_res
      TaskResource
          .select("resource_id, tasks.start_time, tasks.deadline")
          .joins("LEFT JOIN tasks ON tasks.id = task_resources.task_id")
          .to_sql
    end

    def get_projects_res
      ProjectResource
          .select("resource_id, projects.start_date as start_time, projects.deadline")
          .joins("LEFT JOIN projects ON projects.id = project_resources.project_id")
          .to_sql
    end

    def period
      @params[:start_date].to_datetime..@params[:deadline].to_datetime
    end

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
      @resource.company_id = @current_account.company_id
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