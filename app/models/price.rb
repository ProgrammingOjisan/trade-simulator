class Price < ApplicationRecord
    validates :date, presence: true
    validates :price, presence: true, numericality: true
    # validates :fluctuation, numericality: true
    belongs_to :stock
    
    before_save :set_fluctuation
    
    
    private
    
    def set_fluctuation
        return if Price.where(stock_id: self.stock_id).first == nil

        unless self.fluctuation && self == Price.where(stock_id: self.stock_id).first
            current_price = self.price
            last_price = Price.where(stock_id: self.stock_id).last.price
            self.fluctuation = (current_price / last_price - 1)
        end
    end

end
