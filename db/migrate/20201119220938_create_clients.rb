class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string      :name,              null: false, limit: 50
      t.string      :address
      t.string      :vat_number,        limit: 50
      t.boolean     :active,            null: false, default: :false
      t.references  :user_account,     foreign_key: true, null: false
      t.references  :country,          foreign_key: true, null: false
      t.references  :city,             foreign_key: true, null: false
      t.references  :clients_group,    foreign_key: true, null: false
      t.references  :clients_type,     foreign_key: true, null: false
      t.references  :currency,         foreign_key: true, null: false
      t.string      :phone
      t.string      :web_address
      t.string      :kunde_nr
      t.timestamps
    end
  end
end