# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



ProjectStatus.create(name: 'Open', id_name: 'open')
ProjectStatus.create(name: 'In progress', id_name: 'in_progress')
ProjectStatus.create(name: 'Done', id_name: 'done')
ProjectStatus.create(name: 'Reactivated', id_name: 'reactivated')


user = UserAccount.create(
  phone_number: 11111111,
  first_name: 'test',
  last_name: 'account',
  email: 'heypreisler@gmail.com',
  crypted_password: 'testtest',
  phone_number_iso: 47,
  username: 'test account'
  active: true
)

user = UserAccount.create(
  phone_number: 11111111,
  first_name: 'test',
  last_name: 'employee',
  username: 'test_employee',
  email: 'tekuilagirls@gmail.com',
  crypted_password: 'testtest',
  phone_number_iso: 47
  active: true,
  company: Company.first
)

user = UserAccount.create(
  phone_number: 11111111,
  first_name: 'test 2',
  last_name: 'employee',
  username: 'test_employee2',
  email: 'tekuilagirls3@gmail.com',
  crypted_password: 'testtest',
  phone_number_iso: 47,
  active: true,
  company: Company.first
)

emp_role = RoleGroup.find_by_id_name('employee')
UserRole.create(user_account: user, role_group: emp_role)