class Condition < ApplicationRecord

    include TradeSimulation

    validates :buy_condition, presence: true, numericality: true
    validates :sell_condition, presence: true, numericality: true
    validates :duration, presence: true, numericality: { only_integer: true }
    validates :interest, numericality: true, allow_nil: true
    validates :stock_id,  uniqueness: { scope: [:buy_condition, :sell_condition, :duration]  }
    belongs_to :stock
    has_many :favorites, dependent: :destroy
    has_many :favorited, through: :favorites, source: :user
    
    before_save :set_interest

    # Rspecを実行するためにprivateをコメントアウト
    # private
    
    def set_interest
        results = trade_simulation(self.stock_id, self.buy_condition, self.sell_condition, self.duration)
        if !interest
            results = trade_simulation(self.stock_id, self.buy_condition, self.sell_condition, self.duration)
            if results
                self.interest = results[2][0]
            end
        end
    end

end