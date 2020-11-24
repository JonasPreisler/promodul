class FillOrderType < ActiveRecord::Migration[5.2]
  def up
    OrderType.create(name: {en: "Hourly based", no: "Timebasert"}, id_name: :hourly_based)
    OrderType.create(name: {en: "Fixed price", no: "Fast pris"}, id_name: :fixed_price)
    OrderType.create(name: {en: "Internal based", no: "Intern basert"}, id_name: :internal_based)
    OrderType.create(name: {en: "Repetitive", no: "Repeterende"}, id_name: :repetitive)
    OrderType.create(name: {en: "Reclamation", no: "gjenvinning"}, id_name: :reclamation)
  end

  def down
    OrderType.where(id_name: [:hourly_based, :fixed_price, :internal_based, :repetitive, :reclamation]).delete_all
  end
end
