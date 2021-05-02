class AddCompanyToAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_accounts,:company, foreign_key: true, index: true
  end
end
