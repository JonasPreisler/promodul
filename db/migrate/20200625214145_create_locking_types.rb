class CreateLockingTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :locking_types do |t|
      t.json :name,      null: false
      t.string :id_name, limit: 50
    end
  end
end
