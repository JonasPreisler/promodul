class CreateCompanyLogos < ActiveRecord::Migration[5.2]
  def change
    create_table :company_logos do |t|
      t.references :company, foreign_key: true, null: false
      t.string     :logo,   limit: 50
      t.uuid       :uuid,                       null: false
    end

    add_index :company_logos, :uuid, unique: true
  end
end
