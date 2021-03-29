module Resources
  class AttachmentsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(file_params)
      @file_params = file_params
      @errors = []
    end

    def json_view
      { success: true }
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