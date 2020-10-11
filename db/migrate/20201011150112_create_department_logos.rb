class CreateDepartmentLogos < ActiveRecord::Migration[5.2]
  def change
    create_table :department_logos do |t|
      t.references :department, foreign_key: true, null: false
      t.string     :logo,   limit: 50
      t.uuid       :uuid,                       null: false
    end

    add_index :department_logos, :uuid, unique: true
  end
end
