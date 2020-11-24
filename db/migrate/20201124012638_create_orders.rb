class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string      :title,           null: false, limit: 50
      t.string      :description
      t.references  :client,          foreign_key: true, null: false
      t.references  :order_type,      foreign_key: true, null: false
      t.references  :order_status,    foreign_key: true, null: false
      t.references  :user_account,    foreign_key: true, null: true
      t.datetime    :start_time,      null: false
      t.string      :deadline
      t.timestamps
    end
  end
end
