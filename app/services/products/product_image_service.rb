module Products
  class ProductImageService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(image_params)
      @image_params = image_params
      @errors = []
    end

    def create_product_image
      @product_image = ProductImage.new(@image_params)
      @product_image.save
      @errors << fill_errors(@product_image) if @product_image.errors.any?
    end

    def read_image
      find_details_by_uuid
      return if @errors.any?

      unless @product_image.image&.file&.exists?
        fill_custom_errors(self, :picture, :not_found, I18n.t("custom.errors.data_not_found"))
        return
      end

      @product_image.image.file
    end

    def delete_picture
      return if @errors.any?
      find_details_by_uuid
      @product_image.image.remove!
      @errors.concat(fill_errors(@product_image))
    end

    def json_view
      @product_image.as_json(only: [:uuid,:name])
    end

    def destroy_json_view
      { success: true }
    end

    private

    def find_details_by_uuid
      @product_image = ProductImage.find_by(uuid: @image_params[:uuid])
      fill_custom_errors(self, :base, :not_found, I18n.t("custom.errors.data_not_found")) unless @product_image.present?
    end

  end
end