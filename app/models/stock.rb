class Stock < ApplicationRecord
    validates :name, presence: true, length: {maximum: 40}, uniqueness: true
    validates :code, length: {maximum: 8}, uniqueness: true

    has_many :price, dependent: :destroy
    # dependent: :destroy = stockのレコードを削除する際に関連するpriceのレコードも削除
end
