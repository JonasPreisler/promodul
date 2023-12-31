module Projects
  class ProjectsServices
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params, current_user, current_company)
      @params = params
      @errors = []
      @current_user = current_user
      @current_company = current_company
    end

    def json_view
      { project: @project.as_json(include: { user_account: { only: [:first_name, :last_name]}, project_status: { only: [:name, :id_name ]} }) }
    end

    def show_json_view
      { project: @project.as_json(include: { user_account: { only: [:first_name, :last_name]}, project_status: { only: [:name, :id_name ]} }), members: @members, resources: @resources }
    end

    def projects_list_json_view
      { projects: @projects.as_json(include: { user_account: { only: [:first_name, :last_name]}, project_status: { only: [:name, :id_name ]} }) }
    end

    def my_orders_list_json_view
      { orders: @orders.as_json(include: {  client: {only: [:name]  },
                                            order_status: { only: [:name] },
                                            order_type: { only: [:name] },
                                            user_account: { only: [:username] } },
                                only: [:id, :start_time, :title]) }
    end

    def project_calendar_json_view
      { dates: @dates.as_json }
    end

    def destroy_json_view
      { success: true  }
    end

    def get_project_json_view
      { project: @project_edit }
    end

    def create_project
      validate_dates
      validate_users
      validate_resources
      return if errors.any?
      @project = Project.new(@params)
      @project.user_account_id = @current_user.id
      @project.project_id = generate_id
      @project.project_status_id  = ProjectStatus.find_by_id_name(:open).id
      @project.save
      @errors << fill_errors(@project) if @project.errors.any?
      publish_notifications
    end

    def publish_notifications
      return if @errors.any?
      base_uri = 'https://planner-bergen-default-rtdb.europe-west1.firebasedatabase.app/'
      firebase_secret = 'OrbCRPBHsvx9qw0wIou6jCaGiAndHzij2Zd4hhsA'
      firebase = Firebase::Client.new(base_uri, firebase_secret)
      publish_to_admin(firebase)
      publish_to_employee(firebase)
    end

    def publish_to_admin(firebase)
      firebase.push("Super Admin", { type: 'Project',
                                     type_id: @project.id,
                                     title: @project.title,
                                     user_id: UserAccount.joins(user_role: :role_group).where(role_groups: { id_name: "super_admin"}, company_id: @current_company&.id, active: true).first.id,
                                     text: "New project is added into the system" })
    end

    def publish_to_employee(firebase)
      @params["user_account_projects_attributes"].each do |x|
        firebase.push("Employee", { type: 'Project', type_id: @project.id, title: @project.title, user_id: x["user_account_id"], text: "New project assignment" })
      end
    end

    def generate_id
      unic_id = ""
      if Project.last&.id.present?
        number = 5 - Project.last&.id&.to_s&.size.to_i
        number.times { unic_id += "0"}
        unic_id += (Project.last&.id.to_i + 1).to_s
      else
        unic_id = "00001"
      end
      unic_id
    end

    def projects_list
      @projects = Project
                      .joins(user_account: :company)
                      .where(companies: { id: @current_company.id })

      @projects = @projects.where(user_accounts: {id: @current_user.id}) if project_manager?
    end

    def project_manager?
      @current_user.user_role.role_group.id_name.eql?("project_manager")
    end

    def get_project
      @project = Project.find_by_id(@params[:id])
      @project_edit = build_object(@project)
    end

    def build_object(project)
      {
          id: project.id,
          title: project.title,
          description: project.description,
          address: project.address,
          post_number: project.post_number,
          contact_person: project.contact_person,
          start_date: project.start_date,
          deadline: project.deadline,
          users: get_project_users(project),
          resources: get_project_resources(project),
      }
    end

    def get_project_users(project)
      UserAccount
          .select('user_accounts.id, first_name, last_name, user_account_projects.id as project_user_id')
          .joins(user_account_projects: :project)
          .where(projects: {id: project.id })
          .group('user_accounts.id, user_account_projects.id').as_json
    end

    def get_project_resources(project)
      {
          models: get_models(project),
          tools: get_tools(project),
          resources: get_external_resources(project)
      }
    end

    def get_models(project)
      Resource
          .select('resources.id, resources.name, project_resources.id as project_resource_id')
          .joins(:resource_type, project_resources: :project)
          .where(model_on_type: "MachineModel", resource_types: { id_name: "machine"})
          .where(projects: {id: project.id })
          .group('resources.id, project_resources.id').as_json
    end

    def get_tools(project)
      Resource
          .select('resources.id, resources.name, project_resources.id as project_resource_id')
          .joins(:resource_type, project_resources: :project)
          .where(model_on_type: "ToolModel", resource_types: { id_name: "tool"})
          .where(projects: {id: project.id })
          .group('resources.id, project_resources.id').as_json
    end

    def get_external_resources(project)
      Resource
          .select('resources.id, resources.name, project_resources.id as project_resource_id')
          .joins(:resource_type, project_resources: :project)
          .where(model_on_type: "ExternalResourceType", resource_types: { id_name: "external_resource"})
          .where(projects: {id: project.id })
          .group('resources.id, project_resources.id').as_json
    end

    def overview
      @project = Project.find_by_id(@params[:id])
      get_members
      get_resources
    end

    def get_members
      @members = UserAccount
                     .select("user_accounts.id, first_name, last_name, 'employ' AS status")
                     .joins(user_account_tasks: [task: :project])
                     .where(projects: { id: @project.id })
                     .group('user_accounts.id')
                     .as_json

      @members_other = get_other_members

      if @members_other.present?
        @members_other.each do |x|
          @members << {
              id: x["id"],
              first_name: x["first_name"],
              last_name: x["last_name"],
              status: x["status"]
          }
        end
      end

      @members << {
          id: @project.user_account.id,
          first_name: @project.user_account.first_name,
          last_name: @project.user_account.last_name,
          status: "manager"
      }
    end

    def get_other_members
      UserAccount
          .select("user_accounts.id, first_name, last_name, 'employ' AS status")
          .joins(user_account_projects: :project)
          .where(projects: { id: @project.id })
          .group('user_accounts.id')
          .as_json
    end

    def get_resources
      @resources = Resource
                      .select("resources.id, name, resources.description")
                      .joins("LEFT JOIN task_resources ON task_resources.resource_id = resources.id")
                      .joins("LEFT JOIN tasks ON task_resources.task_id = tasks.id")
                      .joins("LEFT JOIN project_resources ON project_resources.resource_id = resources.id")
                      .joins("LEFT JOIN projects ON tasks.project_id = projects.id OR project_resources.project_id = projects.id")
                      .where(projects: { id: @project.id })
                      .group('resources.id')
                      .as_json
    end

    def project_calendar
      @dates = Project
                   .select("projects.id, title, project_id, start_date as start,
                            deadline as end, user_accounts.first_name, user_accounts.last_name, project_statuses.id_name as status")
                   .joins(:project_status, user_account: :company)
                   .where(companies: { id: @current_company.id })

      @dates = @dates.where(user_accounts: {id: @current_user.id}) if project_manager?
    end

    def update_project
      find_project
      return if errors.any?
      validate_update_dates
      return if errors.any?
      @project.update(@params)

      @errors << fill_errors(@project) if @project.errors.any?
    end

    def delete_project
      find_project
      return if errors.any?
      find_tasks
      find_attachments
      ActiveRecord::Base.transaction do
        user_projects = UserAccountProject.where(project_id: @project.id)
        resource_projects = ProjectResource.where(project_id: @project.id)
        user_projects.delete_all if user_projects
        resource_projects.delete_all if resource_projects
        delete_tasks
        @attachments.delete_all
        @project.destroy
      end
      @errors << fill_errors(@project) if @project.errors.any?
    end

    def delete_tasks
      @tasks.each do |t|
        user_tasks = UserAccountTask.where(task_id: t.id)
        resource_tasks = TaskResource.where(task_id: t.id)
        user_tasks.delete_all if user_tasks
        resource_tasks.delete_all if resource_tasks
      end
      @tasks.delete_all
    end

    def progress
      find_status
      find_project_progress
      return if errors.any?
      @project.update(project_status_id: @status.id)
      publish_status_to_admin
    end

    private

    def publish_status_to_admin
      return if @errors.any?
      base_uri = 'https://planner-bergen-default-rtdb.europe-west1.firebasedatabase.app/'
      firebase_secret = 'OrbCRPBHsvx9qw0wIou6jCaGiAndHzij2Zd4hhsA'
      firebase = Firebase::Client.new(base_uri, firebase_secret)
      firebase.push("Super Admin", { type: 'Project',
                                     type_id: @project.id,
                                     title: @project.title,
                                     user_id: UserAccount.joins(user_role: :role_group).where(role_groups: { id_name: "super_admin"}, company_id: @current_company&.id, active: true).first.id,
                                     text: "Project status is changed to #{@status.name}" })
    end

    def find_status
      @status = ProjectStatus.find_by(id_name: params[:id_name])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @status
    end

    def find_project_progress
      return if errors.any?
      @project = Project.find(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @project
    end

    def validate_users
      return if errors.any?
      return if params["user_account_projects_attributes"].nil?
      params["user_account_projects_attributes"].each do |x|
        user_dates = get_user_dates(x["user_account_id"])
        user_dates.reject! { |record| record["start_time"].nil? }
        user_dates.each do |date|
          if period.overlaps?(date["start_time"].to_datetime..date["deadline"].to_datetime)
            fill_custom_errors(self, :base,:invalid, "Employee #{date["first_name"] + " " + date["last_name"]} is busy on this dates")
          end
        end
      end
    end

    def validate_resources
      return if errors.any?
      return if params["project_resources_attributes"].nil?
      params["project_resources_attributes"].each do |x|
        resource_dates = get_resource_dates(x["resource_id"])
        resource_dates.reject! { |record| record["start_time"].nil? }
        resource_dates.each do |date|
          if period.overlaps?(date["start_time"].to_datetime..date["deadline"].to_datetime)
            fill_custom_errors(self, :base,:invalid, "Resource #{date["name"]} is busy on this dates")
          end
        end
      end
    end

    def get_resource_dates(data)
      Resource
          .select("name, start_time, deadline")
          .joins("JOIN  (#{ get_tasks_res } UNION #{ get_projects_res }) obj ON obj.resource_id = resources.id")
          .where(resources: { id: data })
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

    def get_user_dates(user)
      UserAccount
          .select("first_name, last_name, start_time, deadline")
          .joins("JOIN  (#{ get_tasks_user } UNION #{ get_projects_user }) obj ON obj.account_id = user_accounts.id")
          .where(user_accounts: { id: user })
          .as_json
    end

    def get_tasks_user
      UserAccountTask
          .select("user_account_id as account_id, tasks.start_time, tasks.deadline")
          .joins("LEFT JOIN tasks ON tasks.id = user_account_tasks.task_id")
          .to_sql
    end

    def get_projects_user
      UserAccountProject
          .select("user_account_projects.user_account_id as account_id, projects.start_date as start_time, projects.deadline")
          .joins("LEFT JOIN projects ON projects.id = user_account_projects.project_id")
          .to_sql

    end

    def period
      @params["start_date"].to_datetime..@params["deadline"].to_datetime
    end

    def find_project
      @project = Project.find_by_id(@params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @project
    end

    def find_tasks
      @tasks = Task.where(project_id: @project.id)
    end

    def find_attachments
      @attachments = Attachment.where(attached_on_type: "Project", attached_on_id: @project.id)
    end

    def validate_update_dates
      if params[:start_date].to_datetime > params[:deadline].to_datetime
        fill_custom_errors(self, :base,:invalid, "The deadline should be greater than the start date")
      end
    end

    def validate_dates
      if params[:start_date].to_datetime < DateTime.now.beginning_of_day
        fill_custom_errors(self, :base,:invalid, "The project start date can't be less than today")
      end
      return if errors.any?
      if params[:start_date].to_datetime > params[:deadline].to_datetime
        fill_custom_errors(self, :base,:invalid, "The deadline should be greater than the start date")
      end
    end

  end
end