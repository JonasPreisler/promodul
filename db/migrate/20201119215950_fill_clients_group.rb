class FillClientsGroup < ActiveRecord::Migration[5.2]
  def up
    ClientsGroup.create!(name: "Naeringskunde", id_name: :naeringskunde)
    ClientsGroup.create!(name: "Privat kunde",         id_name: :privat_kunde)
    ClientsGroup.create!(name: "Offentlig",    id_name: :offentlig)
  end

  def down
    ClientsGroup.where(id_name: [:naeringskunde, :privat_kunde, :offentlig]).delete_all
  end
end
