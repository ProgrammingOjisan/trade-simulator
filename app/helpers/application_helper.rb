module ApplicationHelper
    
    def simulation(stock_id,buy_condition,sell_condition,duration)
        
        stockprices = Price.where(stock_id: stock_id).last(duration)
        has_stock = nil
        # has_stock is 売買状況を把握するための変数
        start_capital = 100000
        current_capital = start_capital
        valuation_log = []
        
        if !stockprices.present?
            return "Error! Couldn't find Stock Prices"
        elsif stockprices.count < duration
            return "Error! Duration is too long. Please change it to "+Price.where(stock_id: stock_id).count.to_s+" days or less."
        end


        
        stockprices.each_with_index do |stock, i|      
            if stock.fluctuation == nil
                valuation_log << check_valuation(has_stock, stock.price, current_capital)
                next
            end
            
            
            if has_stock
            # has_stockに数値が代入されている(=売りを検討する)場合
                if sell_condition > 0
                    if sell_condition <= stock.fluctuation
                        current_capital += stock.price * has_stock
                        has_stock = nil
                        valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    else
                        valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    end
                elsif sell_condition < 0
                    if sell_condition >= stock.fluctuation
                        current_capital += stock.price * has_stock
                        has_stock = nil
                        valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    else
                        valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    end
                end
    
                else
            # has_stockに数値がなにも代入されていない(=買いを検討する)場合
                if stock.price > current_capital
                    valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    next
                    # 一株も買えない場合はスキップ
                end
                if buy_condition > 0
                    if buy_condition <= stock.fluctuation
                        has_stock = current_capital.div(stock.price)
                        # div is 整数の商を求める際に使う
                        current_capital = current_capital % stock.price
                        # 単元未満株は考慮しないので、余りは現金で保持
                        valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    else
                        valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    end
                elsif buy_condition < 0
                    if buy_condition >= stock.fluctuation
                        has_stock = current_capital.div(stock.price)
                        current_capital = current_capital % stock.price
                        valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    else
                        valuation_log << check_valuation(has_stock, stock.price, current_capital)
                    end
                end
            end
            
            
            if i == (stockprices.length - 1)
            # ループの最後に最終評価額の算出を実行
                valuation = check_valuation(has_stock, stock.price, current_capital)
                profit_and_loss = valuation - start_capital
                interest = (valuation / start_capital) - 1
                return valuation, profit_and_loss, interest, valuation_log
            end
        end
    end
    
    def check_valuation(has_stock, stock_price, current_capital)
        if has_stock
            current_capital + (stock_price * has_stock)
        else
            current_capital
        end
    end


end