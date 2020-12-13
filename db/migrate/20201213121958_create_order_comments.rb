class CreateOrderComments < ActiveRecord::Migration[5.2]
  def change
    create_table :order_comments do |t|
      t.references  :order,     foreign_key: true, null: false
      t.references  :user_account,     foreign_key: true, null: false
      t.string      :comment
      t.timestamps
    end
  end
end
