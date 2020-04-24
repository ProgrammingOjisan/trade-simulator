class Condition < ApplicationRecord
    validates :buy_condion, presence: true, numericality: true
    validates :sell_condion, presence: true, numericality: true
    validates :duration, presence: true, numericality: { only_integer: true }
    validates :interest, numericality: true
    
    belongs_to :stock
    
end
