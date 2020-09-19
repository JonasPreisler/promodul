class RemoveFilledTypes < ActiveRecord::Migration[5.2]
  def up
    ProductType.where(id_name: [:catalog_product, :service, :working_hour]).delete_all
  end

  def dwon
    ProductType.create!(name: "Catalog Product", id_name: :catalog_product)
    ProductType.create!(name: "service",         id_name: :service)
    ProductType.create!(name: "Working Hour",    id_name: :working_hour)
  end
end