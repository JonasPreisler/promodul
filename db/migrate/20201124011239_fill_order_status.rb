class FillOrderStatus < ActiveRecord::Migration[5.2]
  def up
    OrderStatus.create(name: {en: "Open", no: "Åpen"}, id_name: :open)
    OrderStatus.create(name: {en: "Booked", no: "Bestilt"}, id_name: :booked)
    OrderStatus.create(name: {en: "In progress", no: "I prosess"}, id_name: :in_progress)
    OrderStatus.create(name: {en: "Done", no: "Ferdig"}, id_name: :done)
    OrderStatus.create(name: {en: "Canceled", no: "avbrutt"}, id_name: :canceled)
  end

  def down
    OrderStatus.where(id_name: [:open, :booked, :in_progress, :done, :canceled]).delete_all
  end
end
