class Supplier < ApplicationRecord
  validates :active, inclusion: {in: [true, false]}

  belongs_to :integration_system
  belongs_to :business_type

  before_create {self.registration_date = DateTime.now}

end
