class AddBusinessTypes < ActiveRecord::Migration[5.2]
  def up
    BusinessType.create!(name: {en: "default", no: "default"},   id_name: :general)
  end

  def down
    BusinessType.where(id_name: :general).delete_all
  end
end
