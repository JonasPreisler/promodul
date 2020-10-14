module Companies
  class DepartmentsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { department: @department.as_json(include: { country: { only: [:name]}, city: { only: [:name]}, department_logo: { only: [:uuid]}}) }
    end

    def destroy_json_view
      { success: true }
    end

    def department_list_json_view
      { departments: @departments.as_json(include: { country: { only: [:name]}, city: { only: [:name]}, department_logo: { only: [:uuid]}}) }
    end

    def sub_department_list_json_view
      { sub_departments: @sub_departments.as_json(include: { country: { only: [:name]}, city: { only: [:name]}, department_logo: { only: [:uuid]}}) }
    end

    def create_department
      validate_data!
      create_department_obj
    end

    def update_department
      validate_data!
      update_department_obj
    end

    def destroy
      validate_destroy
      find_department
      return if @errors.any?
      @department.active = false
      @department.save
      @errors << fill_errors(@department) if @department.errors.any?
    end

    def department_list
      @departments = Department.joins("LEFT JOIN department_logos ON department_logos.department_id = departments.id").where(parent_id: nil, company_id: params[:company_id], active: true)
    end

    def sub_department_list
      @sub_departments = Department.joins("LEFT JOIN department_logos ON department_logos.department_id = departments.id").where(parent_id: params[:parent_id], active: true)
    end

    private

    def validate_destroy
      fill_custom_errors(self, :base,:invalid, I18n.t("You can not delete Company")) if Department.where(parent_id: params[:id]).present?
    end

    def validate_data!
      validate_country
      validate_city
      validate_company
    end

    def validate_country
      country = Country.find_by_id(params[:country_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless country
    end

    def validate_city
      return if errors.any?
      city = City.find_by_id(params[:city_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless city
    end

    def validate_company
      return if errors.any?
      company = Company.where(id: params[:company_id], active: true).first
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless company
    end

    def create_department_obj
      @department = Department.new(params)
      @department.save
      @errors << fill_errors(@department) if @department.errors.any?
    end

    def update_department_obj
      find_department
      @department.update(params)
      @errors << fill_errors(@department) if @department.errors.any?
    end

    def find_department
      @department = Department.joins("LEFT JOIN department_logos ON department_logos.department_id = departments.id").where(id: params[:id], active: true).last
    end

  end
end