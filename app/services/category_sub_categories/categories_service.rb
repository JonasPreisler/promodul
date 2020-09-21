module CategorySubCategories
  class CategoriesService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(category_params)
      @category_params = category_params
      @errors = []
    end

    def json_view
      { category: @category.as_json }
    end

    def destroy_json_view
      { success: true  }
    end

    def list_json_view
      { categories: @category.as_json }
    end

    def create_category
      @category = Category.new(@category_params)
      @category.id_name = @category_params[:name]["en"].downcase.parameterize(separator: '_')
      @category.save

      @errors << fill_errors(@category) if @category.errors.any?
    end

    def update_category
      find_category
      set_name_object
      return if errors.any?
      @category.assign_attributes(@category_params)
      @category.save

      @errors << fill_errors(@category) if @category.errors.any?
    end

    def destroy
      find_category
      validate_category
      return if @errors.any?
      @category.destroy
      @errors << fill_errors(@category) if @category.errors.any?
    end

    def category_list
      @category = Category.all
      fill_custom_errors(self, :base, :not_found, I18n.t("custom.errors.data_not_found")) if @category.empty?
    end

    private

    def set_name_object
      return if @errors.any?
      key = @category_params[:name].keys.first
      obj_dif = @category[:name].except(key)
      @category_params[:name].merge!(obj_dif)
    end

    def find_category
      @category = Category.find_by_id(@category_params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @category
    end

    def validate_category
      return if errors.any?
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.validation.category_validation")) if SubCategory.where(category_id: @category.id).present?
    end
  end
end