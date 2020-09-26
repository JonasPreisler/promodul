class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.json :name,         null: false
      t.string :symbol,     null: false, limit: 20
      t.string :code,       null: false, limit: 3
    end

    add_index :currencies, :code, unique: true
  end
end
