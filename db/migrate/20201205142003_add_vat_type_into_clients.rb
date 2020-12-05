class AddVatTypeIntoClients < ActiveRecord::Migration[5.2]
  def up
    add_reference :clients,:product_vat_type, foreign_key: true, index: true
  end

  def down
    remove_reference :clients, :product_vat_type
  end
end
