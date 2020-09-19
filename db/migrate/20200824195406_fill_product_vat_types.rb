class FillProductVatTypes < ActiveRecord::Migration[5.2]
  def up
    ProductVatType.create!(name: "0% tax",   id_name: :tax_0_percent)
    ProductVatType.create!(name: "6% tax",   id_name: :tax_6_percent)
    ProductVatType.create!(name: "15% tax",  id_name: :tax_15_percent)
    ProductVatType.create!(name: "25% tax",  id_name: :tax_25_percent)
  end

  def down
    ProductVatType.where(id_name: [:tax_0_percent, :tax_6_percent, :tax_15_percent, :tax_25_percent]).delete_all
  end
end
