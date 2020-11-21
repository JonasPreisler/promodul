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
      { client: @client.as_json(include: { clients_group: { only: [:name]}, clients_type: { only: [:name]} }, only: [:name] ) }
    end

    def client_type_json_view
      { types: @types.as_json }
    end

    def client_group_json_view
      { groups: @groups.as_json }
    end

    #def destroy_json_view
    #  { success: true }
    #end

    def clients_list_json_view
      { clients: @clients.as_json(include: { clients_group: { only: [:name]}, clients_type: { only: [:name]} }, only: [:id, :name] ) }
    end

    #def sub_company_list_json_view
    #  { sub_companies: @sub_companies.as_json(include: { country: { only: [:name]}, city: { only: [:name]}, company_logo: { only: [:uuid]}}) }
    #end

    def create_client
      validate_data!
      create_city_obj
    end

    def get_types
      @types = ClientsType.all
    end

    def get_groups
      @groups = ClientsGroup.all
    end

    def client_list
      @clients = Client.where(active: true)
    end

    #def update_company
    #  validate_data!
    #  update_company_obj
    #end

    def show
      find_client
    end

    #def destroy
    #  validate_destroy
    #  find_company
    #  return if @errors.any?
    #  @company.active = false
    #  @company.save
    #  @errors << fill_errors(@company) if @company.errors.any?
    #end



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

    def find_client
      @client = Client.where(id: params[:id], active: true).last
    end
  end
end