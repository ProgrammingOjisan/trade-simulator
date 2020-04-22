class Stock < ApplicationRecord
    validates :name, presence: true, length: {maximum: 40}, uniqueness: true
    validates :code, length: {maximum: 8}, uniqueness: true
end
