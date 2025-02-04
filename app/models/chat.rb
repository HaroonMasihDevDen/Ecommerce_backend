class Chat < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :admin_user, optional: true

  validates :question, presence: true
end
