module Companies
  class DepartmentLogoService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(logo_params)
      @logo_params = logo_params
      @errors = []
    end

    def create_department_logo
      @department_logo = DepartmentLogo.where(department_id: @logo_params[:department_id]).first_or_initialize
      @department_logo.update(logo: @logo_params[:logo])
      errors.concat(@department_logo.errors.to_a) if @department_logo.errors.any?
    end

    def read_logo
      find_details_by_uuid
      return if @errors.any?

      unless @department_logo.logo&.file&.exists?
        fill_custom_errors(self, :picture, :not_found, I18n.t("custom.errors.data_not_found"))
        return
      end

      @department_logo.logo.file
    end

    def delete_logo
      return if @errors.any?
      find_details_by_uuid
      @department_logo.logo.remove!
      @errors.concat(fill_errors(@department_logo))
    end

    def json_view
      @department_logo.as_json(only: [:uuid,:name])
    end

    def destroy_json_view
      { success: true }
    end

    private

    def find_details_by_uuid
      @department_logo = DepartmentLogo.find_by(uuid: @logo_params[:uuid])
      fill_custom_errors(self, :base, :not_found, I18n.t("custom.errors.data_not_found")) unless @department_logo.present?
    end
  end
end