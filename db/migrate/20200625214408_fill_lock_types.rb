class FillLockTypes < ActiveRecord::Migration[5.2]
  def change
    LockingType.create!(name: {"en"=>"Password Error Limit"}, id_name: "password_error_limited")
  end
end
