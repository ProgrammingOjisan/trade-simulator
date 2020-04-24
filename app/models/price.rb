class Price < ApplicationRecord
    validates :date, presence: true
    validates :price, presence: true, numericality: true
    validates :fluctuation, numericality: true, allow_nil: true
    belongs_to :stock
    
    before_save :set_fluctuation
    
    def simulation(stock_id,buy_condition,sell_condition,duration)
    
        stockprices = Price.where(stock_id: stock_id).last(duration)
        has_stock = nil
        # has_stock is 売買状況を把握するための変数
        start_capital = 1000000
        current_captial = start_capital
    
        stockprices.each_with_index do |stock, i|      
            if has_stock
            # has_stockに数値が代入されている(=売りを検討する)場合
                if sell_condition > 0
                    if sell_condition >= stock.fluctuation
                        current_captial += stock.price * has_stock
                        has_stock = nil
                    end
                elsif sell_condition < 0
                    if sell_condition <= stock.fluctuation
                        current_captial += stock.price * has_stock
                        has_stock = nil
                    end
                end
    
            else
            # has_stockに数値がなにも代入されていない(=買いを検討する)場合
                if stock.price > current_captial
                    next
                    # 一株も買えない場合はスキップ
                end
                if buy_condition > 0
                    if buy_condition >= stock.fluctuation
                        has_stock = current_captial.div(stock.price)
                        # div is 整数の商を求める際に使う
                        current_captial = current_captial % stock.price
                        # 単元未満株は考慮しないので、余りは現金で保持
                    end
                elsif buy_condition < 0
                    if buy_condition <= stock.fluctuation
                        has_stock = current_captial.div(stock.price)
                        current_captial = current_captial % stock.price
                    end
                end
            end
    
            if i == (stockprices.length - 1)
            # ループの最後に最終評価額の算出を実行
                valuation = current_captial + (stock.price * has_stock)
                profit_and_loss = valuation - start_capital
                interest = valuation / start_capital
                return valuation, profit_and_loss, interest
            end
        end
    end
    
    
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
