module Clients
  class ContactsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { contact: @contact.as_json(only: [:id, :first_name, :last_name, :email, :phone, :position, :created_at] )}
    end

    #def client_type_json_view
    #  { types: @types.as_json }
    #end
    #
    #def client_group_json_view
    #  { groups: @groups.as_json }
    #end
    #
    #def destroy_json_view
    #  { success: true }
    #end

    #def show_json_view
    #  { client: @client.as_json(include: { clients_group: { only: [:id, :name]},
    #                                       clients_type: { only: [:id, :name] },
    #                                       currency: { only: [:id, :name, :code, :symbol] },
    #                                       country: { only: [:name]},
    #                                       city: { only: [:name]  } }) }
    #end

    #def clients_list_json_view
    #  { clients: @clients.as_json(include: { clients_group: { only: [:name]}, clients_type: { only: [:name]} }, only: [:id, :name] ) }
    #end

    def create_contact
      validate_data!
      create_client_obj
    end

    #def client_list
    #  @clients = Client.where(active: true)
    #end
    #
    #def update_client
    #  validate_data!
    #  update_client_obj
    #end
    #
    #def show
    #  find_client
    #end
    #
    #def delete_client
    #  find_client
    #  return if @errors.any?
    #  @client.active = false
    #  @client.save
    #  @errors << fill_errors(@client) if @client.errors.any?
    #end

    private

    def validate_data!
      validate_client
    end

    def create_client_obj
      return if errors.any?
      @contact = ClientContact.new(params)
      @contact.save
      @errors << fill_errors(@contact) if @contact.errors.any?
    end

    #def update_client_obj
    #  find_client
    #  @client.update(params)
    #  @errors << fill_errors(@client) if @client.errors.any?
    #end

    def validate_client
      binding.pry
      @client = Client.where(id: params[:client_id], active: true).last
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @client
    end
  end
end