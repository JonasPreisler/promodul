module Clients
  class Service
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { client: @client.as_json(include: { country: { only: [:name]}, city: { only: [:name]}, company_logo: { only: [:uuid]}}) }
    end

    #def destroy_json_view
    #  { success: true }
    #end
    #
    #def company_list_json_view
    #  { companies: @companies.as_json(include: { country: { only: [:name]}, city: { only: [:name]}, company_logo: { only: [:uuid]}}) }
    #end
    #
    #def sub_company_list_json_view
    #  { sub_companies: @sub_companies.as_json(include: { country: { only: [:name]}, city: { only: [:name]}, company_logo: { only: [:uuid]}}) }
    #end

    def create_client
      #ToDo: Ask Roy if Order should include client?
      binding.pry
      validate_data!
      create_city_obj
    end

    #def update_company
    #  validate_data!
    #  update_company_obj
    #end
    #
    #def show
    #  find_company
    #end
    #
    #def destroy
    #  validate_destroy
    #  find_company
    #  return if @errors.any?
    #  @company.active = false
    #  @company.save
    #  @errors << fill_errors(@company) if @company.errors.any?
    #end
    #
    #def company_list
    #  @companies = Company.joins("LEFT JOIN company_logos ON company_logos.company_id = companies.id").where(parent_id: nil, active: true)
    #end
    #
    #def sub_company_list
    #  @sub_companies = Company.joins("LEFT JOIN company_logos ON company_logos.company_id = companies.id").where(parent_id: params[:parent_id], active: true)
    #end

    private

    #def validate_destroy
    #  fill_custom_errors(self, :base,:invalid, I18n.t("You can not delete Company")) if Company.where(parent_id: params[:id]).present?
    #end

    def validate_data!
      validate_country
      validate_city
      validate_currency
      validate_user_account
      validate_clients_group
      validate_clients_type
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

    def validate_currency
      return if errors.any?
      currency = Currency.find_by_id(params[:currency_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless currency
    end

    def validate_user_account
      return if errors.any?
      user_account = UserAccount.find_by_id(params[:user_account_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless user_account
    end

    def validate_clients_group
      return if errors.any?
      group = ClientsGroup.find_by_id(params[:clients_group_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless group
    end

    def validate_clients_type
      return if errors.any?
      type = ClientsType.find_by_id(params[:clients_type_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless type
    end

    def create_city_obj
      return if errors.any?
      binding.pry
      @client = Client.new(params)
      @client.active = true
      @client.save
      binding.pry
      @errors << fill_errors(@client) if @client.errors.any?
    end

    #def update_company_obj
    #  find_company
    #  @company.update(params)
    #  @errors << fill_errors(@company) if @company.errors.any?
    #end
    #
    #def find_company
    #  @company = Company.joins("LEFT JOIN company_logos ON company_logos.company_id = companies.id").where(id: params[:id], active: true).last
    #end
  end
end