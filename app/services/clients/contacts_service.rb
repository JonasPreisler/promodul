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

    def contacts_list_json_view
      { contacts: @clients.as_json(only: [:id, :first_name, :last_name, :email, :phone, :position, :created_at] ) }
    end

    def destroy_json_view
      { success: true }
    end

    #def show_json_view
    #  { client: @client.as_json(include: { clients_group: { only: [:id, :name]},
    #                                       clients_type: { only: [:id, :name] },
    #                                       currency: { only: [:id, :name, :code, :symbol] },
    #                                       country: { only: [:name]},
    #                                       city: { only: [:name]  } }) }
    #end



    def create_contact
      validate_data!
      create_client_obj
    end

    def contact_list
      @clients = ClientContact.where(client_id: params[:client_id])
    end

    def update_client
      validate_data!
      update_contact_obj
    end

    def show
      find_contact
    end

    def delete_client
      find_contact
      return if @errors.any?
      @contact.destroy
      @errors << fill_errors(@contact) if @contact.errors.any?
    end

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

    def update_contact_obj
      find_contact
      return if errors.any?
      @contact.update(params)
      @errors << fill_errors(@contact) if @contact.errors.any?
    end

    def validate_client
      @client = Client.where(id: params[:client_id], active: true).last
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @client
    end

    def find_contact
      @contact = ClientContact.find_by_id(params[:id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless @contact
    end
  end
end