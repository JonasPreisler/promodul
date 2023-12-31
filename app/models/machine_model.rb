class MachineModel < ApplicationRecord
  validates :name,    presence: true
  validates :id_name, presence: true

  has_many :resources, as: :model_on
end
