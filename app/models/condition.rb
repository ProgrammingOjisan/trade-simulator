class Condition < ApplicationRecord
    validates :buy_condition, presence: true, numericality: true
    validates :sell_condition, presence: true, numericality: true
    validates :duration, presence: true, numericality: { only_integer: true }
    validates :interest, numericality: true
    validates :stock_id,  uniqueness: { scope: [:buy_condition, :sell_condition, :duration]  }
    belongs_to :stock
end
