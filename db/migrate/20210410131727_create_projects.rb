class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :project_id
      t.string :address
      t.string :post_number
      t.string :contact_person
      t.references  :user_account,    foreign_key: true, null: true
      t.timestamps
    end
  end
end
