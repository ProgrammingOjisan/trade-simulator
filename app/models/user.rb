class User < ApplicationRecord
    before_save { self.email.downcase! }
    has_secure_password
    has_many :favorites, dependent: :destroy
    has_many :favoriting, through: :favorites, source: :condition
    has_many :condition, dependent: :destroy
    validates :name, presence: true, length: { maximum: 20 }
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z/ },
                    uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 8 }
    
    def favorite(condition)
        unless favorite?(condition)
            self.favorites.find_or_create_by(condition_id: condition.id)
        end
    end

    def unfavorite(condition)
        favorite = self.favorites.find_by(condition_id: condition)
        favorite.destroy if favorite
    end

    def favorite?(condition)
        self.favoriting.include?(condition)
    end

end