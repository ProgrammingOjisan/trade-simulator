class Price < ApplicationRecord
    validates :date, presence: true,  uniqueness: { scope: :stock_id }
    validates :price, presence: true, numericality: true
    validates :fluctuation, numericality: true, allow_nil: true
    belongs_to :stock
    
    before_save :set_fluctuation

    
    # private
    
    def set_fluctuation
		first_price = Price.where(stock_id: self.stock_id).order(:date).first
        if !self.fluctuation && first_price && self != first_price && self.date > first_price.date
            current_price = self.price
            previous_price = Price.where(stock_id: self.stock_id).where("date < ?", self.date).order(:date).last.price
            self.fluctuation = (current_price / previous_price - 1)		
        end
    end
end