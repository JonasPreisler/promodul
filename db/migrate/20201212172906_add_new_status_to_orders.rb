class AddNewStatusToOrders < ActiveRecord::Migration[5.2]
  def up
    OrderStatus.create(name: {en: "claimed", no: "kreve"}, id_name: :claimed)

  end

  def down
    OrderStatus.where(id_name: :claimed).delete_all
  end
end
