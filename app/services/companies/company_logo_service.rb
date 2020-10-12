module Companies
  class CompanyLogoService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors

    def initialize(logo_params)
      @logo_params = logo_params
      @errors = []
    end

    def create_company_logo
      #@product_price = ProductPrice.where(product_id: price_params[:product_id]).first_or_initialize
      #@product_price.update(list_price_type: price_params[:list_price_type],
      #                      list_price_amount: price_params[:list_price_amount],
      #                      manufacturing_cost: price_params[:manufacturing_cost])
      #errors.concat(@product_price.errors.to_a) if @product_price.errors.any?


      @company_logo = CompanyLogo.where(company_id: @logo_params[:company_id]).first_or_initialize
      @company_logo.update(logo: @logo_params[:logo])
      #@company_logo.save
      errors.concat(@company_logo.errors.to_a) if @company_logo.errors.any?
    end

    def read_logo
      find_details_by_uuid
      return if @errors.any?

      unless @company_logo.logo&.file&.exists?
        fill_custom_errors(self, :picture, :not_found, I18n.t("custom.errors.data_not_found"))
        return
      end

      @company_logo.logo.file
    end

    def delete_logo
      return if @errors.any?
      find_details_by_uuid
      @company_logo.logo.remove!
      @errors.concat(fill_errors(@company_logo))
    end

    def json_view
      @company_logo.as_json(only: [:uuid,:name])
    end

    def destroy_json_view
      { success: true }
    end

    private

    def find_details_by_uuid
      @company_logo = CompanyLogo.find_by(uuid: @logo_params[:uuid])
      fill_custom_errors(self, :base, :not_found, I18n.t("custom.errors.data_not_found")) unless @company_logo.present?
    end
  end
end