class Stock < ApplicationRecord
    validates :name, presence: true, length: {maximum: 40}, uniqueness: {case_sensitive: false }
    validates :code, length: {maximum: 8}, uniqueness: {case_sensitive: false }

    has_many :condition, dependent: :destroy
    has_many :price, dependent: :destroy
    # dependent: :destroy = stockのレコードを削除する際に関連するprice,conditionのレコードも削除
end
