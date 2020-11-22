class CreateClientContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :client_contacts do |t|
      t.string      :first_name,              null: false, limit: 50
      t.string      :last_name
      t.string      :email,                   limit: 50
      t.string      :phone,                   null: false
      t.string      :position
      t.references  :client,         foreign_key: true, null: false
      t.timestamps
    end
  end
end
