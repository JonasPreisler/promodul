module Products
  class ProductTypeService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors


    def initialize(product_type_params)
      @params = product_type_params
      @errors = []
    end

    def json_view
      { product_type: @product_type.as_json }
    end

    def destroy_json_view
      { success: true  }
    end

    def list_json_view
      { product_types: @product_types.as_json }
    end

    def create
      @product_type = ProductType.new(@params)
      @product_type.id_name = @params[:name]["en"].downcase.parameterize(separator: '_')
      @product_type.save

      @errors << fill_errors(@product_type) if @product_type.errors.any?
    end

    def update
      find_type
      set_name_object
      return if errors.any?
      @product_type.assign_attributes(@params)
      @product_type.save

      @errors << fill_errors(@product_type) if @product_type.errors.any?
    end

    def destroy
      find_type
      return if @errors.any?
      @product_type.destroy
      @product_type << fill_errors(@product_type) if @product_type.errors.any?
    end

    def list
      @product_types = ProductType.all
      #fill_custom_errors(self, :base, :not_found, I18n.t("custom.errors.data_not_found")) if !@product_type.present?
    end


    private

    def set_name_object
      return if @errors.any?
      key = @params[:name].keys.first
      obj_dif = @product_type[:name].except(key)
      @params[:name].merge!(obj_dif)
    end

    def find_type
      @product_type = ProductType.find_by_id(@params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @product_type
    end
  end
end