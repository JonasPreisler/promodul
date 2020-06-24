class TermsAndCondition < ApplicationRecord
  multilanguage [:terms_and_condition, :description]

  validates :active_from, presence: true
  validates :version,     presence: true, length: {maximum: 50}
end
