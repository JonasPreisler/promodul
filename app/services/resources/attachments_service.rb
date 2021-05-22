module Resources
  class AttachmentsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(current_account, file_params)
      @current_account = current_account
      @file_params = file_params
      @errors = []
    end

    def json_view
      { success: true }
    end

    def get_files_json_view
      { files: @files.as_json }
    end

    def create_file
      @file = Attachment.new(@file_params)
      @file.save
      @errors << fill_errors(@file) if @file.errors.any?
    end

    def read_file
      find_details_by_uuid
      return if @errors.any?
      unless @file.file&.file&.exists?
        fill_custom_errors(self, :picture, :not_found, I18n.t("custom.errors.data_not_found"))
        return
      end
      @file.file.file
    end

    def files
      resource = get_resource
      user = get_user
      project = get_project

      base_query = ""
      base_query += "attached_on_type = :attached_type" if @file_params[:attached_on_type]
      base_query += " AND attached_on_id = :attached_id" if @file_params[:attached_on_id]

      @files = Attachment
                   .select('id, pol_type, type_on, name, file as file_name, uuid')
                   .joins("JOIN (#{ resource } UNION #{ user } UNION #{ project }) attached_obj ON attached_obj.obj_id = attachments.attached_on_id AND attached_obj.pol_type = attachments.attached_on_type")
                   .where(base_query, attached_type: @file_params[:attached_on_type], attached_id: @file_params[:attached_on_id])
                   .where(is_active: true)
                   .group_by{ |obj| obj.pol_type}

      @files['Resource'] = @files['Resource'].group_by{ |obj| obj.type_on } if @files['Resource'].present?
      @files['Resource'].map{ |k, v| @files['Resource'][k] = v.group_by{ |obj| obj.name }}
      @files['UserAccount'] = @files['UserAccount'].group_by{ |obj| obj.name } if @files['UserAccount'].present?
      @files['Project'] = @files['Project'].group_by{ |obj| obj.type_on } if @files['Project'].present?

    end

    def get_resource
      base_query = ""
      base_query += "model_on_type = :model_type_on" if @file_params[:model_on_type]
      base_query += " AND model_on_id = :model_type_id" if @file_params[:model_on_id]
      Resource
          .select("id as obj_id, 'Resource' as pol_type, model_on_type as type_on, name")
          .where(base_query, model_type_on: @file_params[:model_on_type], company_id: @current_account.company_id)
          .to_sql
    end

    def get_user
      UserAccount
          .select("user_accounts.id as obj_id, 'UserAccount' as pol_type, 'customer' as type_on, concat(first_name, ' ', last_name) as name")
          .where(company_id: @current_account.company_id)
          .to_sql
    end

    def get_project
      Project
          .select("projects.id as obj_id, 'Project' as pol_type, title as type_on, title as name")
          .joins(:user_account)
          .where(user_accounts: { company_id: @current_account.company_id })
          .to_sql
    end

    def delete_picture
      return if @errors.any?
      find_details_by_uuid
      @product_image.image.remove!
      @errors.concat(fill_errors(@product_image))
    end

    def read_file_json_view
      @product_image.as_json(only: [:uuid,:name])
    end

    def destroy_json_view
      { success: true }
    end

    private

    def find_details_by_uuid
      @file = Attachment.find_by(uuid: @file_params[:uuid])
      fill_custom_errors(self, :base, :not_found, I18n.t("custom.errors.data_not_found")) unless @file.present?
    end
  end
end