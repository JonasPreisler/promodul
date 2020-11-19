class FillClientsType < ActiveRecord::Migration[5.2]
  def up
    ClientsType.create!(name: "Sikkerhet", id_name: :sikkerhet)
    ClientsType.create!(name: "Elektro",         id_name: :elektro)
    ClientsType.create!(name: "Bugg",    id_name: :bugg)
  end

  def down
    ClientsType.where(id_name: [:sikkerhet, :elektro, :bugg]).delete_all
  end
end
