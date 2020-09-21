module CategorySubCategories
  class SubCategoriesService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(category_params)
      @sub_category_params = category_params
      @errors = []
    end

    def json_view
      { sub_category: @sub_category.as_json }
    end

    def destroy_json_view
      { success: true  }
    end

    def list_json_view
      { sub_categories: @sub_category.as_json }
    end

    def create_sub_category
      @sub_category = SubCategory.new(@sub_category_params)
      @sub_category.id_name = @sub_category_params[:name]["en"].downcase.parameterize(separator: '_')
      @sub_category.save

      @errors << fill_errors(@sub_category) if @sub_category.errors.any?
    end

    def update_sub_category
      find_sub_category
      set_name_object
      return if errors.any?
      @sub_category.assign_attributes(@sub_category_params)
      @sub_category.save

      @errors << fill_errors(@sub_category) if @sub_category.errors.any?
    end

    def destroy
      find_sub_category
      return if @errors.any?
      @sub_category.destroy
      @errors << fill_errors(@sub_category) if @sub_category.errors.any?
    end

    def sub_category_list
      @sub_category = SubCategory.where(category_id: @sub_category_params[:category_id])
      #fill_custom_errors(self, :base, :not_found, I18n.t("custom.errors.data_not_found")) if @sub_category.empty?
    end

    private

    def set_name_object
      return if @errors.any?
      key = @sub_category_params[:name].keys.first
      obj_dif = @sub_category[:name].except(key)
      @sub_category_params[:name].merge!(obj_dif)
    end

    def find_sub_category
      @sub_category = SubCategory.find_by_id(@sub_category_params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @sub_category
    end
  end
end