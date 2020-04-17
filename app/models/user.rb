class User < ApplicationRecord
    before_save { self.email.downcase! }
    has_secure_password
    validates :name, presence: true, length: { maximum: 20 }
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z/ },
                    uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 8 }
end