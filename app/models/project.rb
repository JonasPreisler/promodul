class Project < ApplicationRecord
  belongs_to :user_account, optional: true
  has_many :attachments, as: :attached_on
end
