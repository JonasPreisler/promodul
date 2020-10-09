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
      { department: @department.as_json(include: { country: { only: [:name]}, city: { only: [:name]}}) }
    end

    def destroy_json_view
      { success: true }
    end

    def department_list_json_view
      { departments: @departments.as_json }
    end

    def sub_department_list_json_view
      { sub_departments: @sub_departments.as_json() }
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
      @department.destroy
      @errors << fill_errors(@department) if @department.errors.any?
    end

    def department_list
      @departments = Department.where(parent_id: nil)
    end

    def sub_department_list
      @sub_departments = Department.where(parent_id: params[:parent_id])
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
      company = Company.find_by_id(params[:company_id])
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
      @department = Department.find(params[:id])
    end

  end
end