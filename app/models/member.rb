class Member < ApplicationRecord
  validates :name, :surname, :email_address, presence: true
  
end
