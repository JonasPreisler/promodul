class AddCompanyToResource < ActiveRecord::Migration[5.2]
  def change
    add_reference :resources,:company, foreign_key: true, index: true
  end
end
