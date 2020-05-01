class Condition < ApplicationRecord

    include ApplicationHelper

    validates :buy_condition, presence: true, numericality: true
    validates :sell_condition, presence: true, numericality: true
    validates :duration, presence: true, numericality: { only_integer: true }
    validates :interest, numericality: true, allow_nil: true
    validates :stock_id,  uniqueness: { scope: [:buy_condition, :sell_condition, :duration]  }
    belongs_to :stock
    has_many :condition, dependent: :destroy
    
    before_save :set_interest

    
    # private
    
    def set_interest
        results = simulation(self.stock_id, self.buy_condition, self.sell_condition, self.duration)
        if !interest
            results = simulation(self.stock_id, self.buy_condition, self.sell_condition, self.duration)
            if results
                self.interest = results[2]
            end
        end
    end

end
