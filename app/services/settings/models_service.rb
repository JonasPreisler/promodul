module Settings
  class ModelsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(current_account, params)
      @current_account = current_account
      @params = params
      @errors = []
      @id_name = params[:name].gsub(/\s+/, "").downcase if params[:name].present?
    end

    def machine_model_json_view
      { machine_model: @machine.as_json }
    end

    def tool_model_json_view
      { tool_model: @tool.as_json }
    end

    def external_source_type_json_view
      { external_type: @external.as_json }
    end

    def destroy_machine_model_json_view
      { success: true }
    end

    def destroy_external_source_type_json_view
      { success: true }
    end

    def destroy_tool_model_json_view
      { success: true }
    end

    def machine_models_json_view
      { machine_models: @machines.as_json }
    end

    def tool_models_json_view
      { tool_models: @tools.as_json }
    end

    def external_source_types_json_view
      { external_types: @externals.as_json }
    end

    def machine_model
      @machine = MachineModel.where(id_name: @id_name, company_id: @current_account.company_id).first_or_initialize
      @machine.update(name: params[:name])
      errors.concat(@machine.errors.to_a) if @machine.errors.any?
    end

    def tool_model
      @tool = ToolModel.where(id_name: @id_name, company_id: @current_account.company_id).first_or_initialize
      @tool.update(name: params[:name])
      errors.concat(@tool.errors.to_a) if @tool.errors.any?
    end

    def source_type
      @external = ExternalResourceType.where(id_name: @id_name, company_id: @current_account.company_id).first_or_initialize
      @external.update(name: params[:name])
      errors.concat(@external.errors.to_a) if @external.errors.any?
    end

    def machine_models
      @machines = MachineModel.where(company_id: @current_account.company_id)
    end

    def tool_models
      @tools = ToolModel.where(company_id: @current_account.company_id)
    end

    def source_types
      @externals = ExternalResourceType.where(company_id: @current_account.company_id)
    end

    def destroy_machine_model
      @machine = MachineModel.find(params[:id])
      @machine.destroy
      @errors << fill_errors(@machine) if @machine.errors.any?
    end

    def destroy_external_source_type
      @external = ExternalResourceType.find(params[:id])
      @external.destroy
      @errors << fill_errors(@external) if @external.errors.any?
    end

    def destroy_tool_model
      @tool = ToolModel.find(params[:id])
      @tool.destroy
      @errors << fill_errors(@tool) if @tool.errors.any?
    end
  end
end