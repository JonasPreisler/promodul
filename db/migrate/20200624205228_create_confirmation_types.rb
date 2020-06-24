class CreateConfirmationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :confirmation_types do |t|
      t.string :name,    limit: 150
      t.string :id_name, limit: 50
    end
  end
end
