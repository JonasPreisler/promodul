class FillConfirmationTypes < ActiveRecord::Migration[5.2]
  def change
    ConfirmationType.create_with(name: 'Phone number change').find_or_create_by!(id_name: 'change_phone_number')
    ConfirmationType.create_with(name: 'Registration').find_or_create_by!(id_name: 'registration')
    ConfirmationType.create_with(name: 'Password recovery').find_or_create_by!(id_name: 'password_recovery')
  end
end
