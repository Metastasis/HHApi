class User < ApplicationRecord
  before_save { self.email = email.downcase }

  REGEXP_VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum:50}
  validates :password, presence: true,length: {minimum: 6}
  validates :email, presence: true,
    length: {maximum:255},
    format: {with:REGEXP_VALID_EMAIL},
    uniqueness:{case_sensitive: false}

  has_secure_password
end
