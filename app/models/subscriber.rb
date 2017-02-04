class Subscriber < ApplicationRecord
  validates :firstname, :lastname, :email, :presence => true
  validates :email, uniqueness: true
end
