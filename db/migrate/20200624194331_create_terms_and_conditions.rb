class CreateTermsAndConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :terms_and_conditions do |t|
      t.datetime :active_from,  null: false
      t.string :version,        null: false, limit: 50
      t.string :description
      t.string :terms_and_condition
    end
  end
end
