class Price < ApplicationRecord
    validates :date, presence: true
    validates :price, presence: true, numericality: true
    validates :fluctuation, numericality: true, allow_nil: true
    belongs_to :stock
    
    before_save :set_fluctuation

    
    # private
    
    def set_fluctuation
        first_price = Price.where(stock_id: self.stock_id).first
        if !fluctuation && first_price && self != first_price
        # fluctuationがnilかつすでにfirst_priceが存在する場合にfluctuationに値を代入する
            current_price = self.price
            last_price = Price.where(stock_id: self.stock_id).last.price
            self.fluctuation = (current_price / last_price - 1)
        end
    end

end
