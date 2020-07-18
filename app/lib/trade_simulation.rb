module TradeSimulation
    def trade_simulation(stock_id,buy_condition,sell_condition,duration)

        return "Error! There are not any Stock Prices" if !Price.where(stock_id: stock_id).present?

        latest_date = Price.where(stock_id: stock_id).last.date
        start_date = latest_date.ago(duration.years)
    	stockdata = Price.where(stock_id: stock_id, date: start_date..latest_date).order(:date)	

        start_capital = 1000000
        current_capital = [start_capital,start_capital]
        has_stock = [nil,nil]
        # has_stock is 売買状況を把握するための変数
        valuation_log = [{name: "YOUR CONDITION", data: {}},{name: (Stock.find(stock_id).name + " [" + Stock.find(stock_id).code + "]"), data: {}}]
        active_trade_log = valuation_log[0]
        passive_trade_log = valuation_log[1]
        
        
        stockdata.each_with_index do |daily_data, i|

            # 指数用処理
            if i == 0
              # 初回に指数用のトレードを実施
                if daily_data.price > current_capital[1]
                    passive_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") =>  current_capital[1]})
                else
                    has_stock[1] = current_capital[1].div(daily_data.price)
                        # div is 整数の商を求める際に使う
                        current_capital[1] = current_capital[1] % daily_data.price
                        # 単元未満株は考慮しないので、余りは現金で保持
                        passive_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[1], daily_data.price, current_capital[1]).round})               
                end
            else
                    passive_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[1], daily_data.price, current_capital[1]).round})
            end

            # 指定条件用処理
            if daily_data.fluctuation == nil
              # 変動率がnilの場合はスキップ
              active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
              next
            end
          
          
            if has_stock[0]
            # has_stock[0]に数値が代入されている(=売りを検討する)場合
                if sell_condition > 0
                    if sell_condition <= daily_data.fluctuation
                        current_capital[0] += daily_data.price * has_stock[0]
                        has_stock[0] = nil
                        active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                    else
                        active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                    end
                elsif sell_condition < 0
                    if sell_condition >= daily_data.fluctuation
                        current_capital[0] += daily_data.price * has_stock[0]
                        has_stock[0] = nil
                        active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                    else
                        active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                    end
                end
            else
            # has_stock[0]に数値がなにも代入されていない(=買いを検討する)場合
            if daily_data.price > current_capital[0]
                active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                next
                # 一株も買えない場合はスキップ
            end
            if buy_condition > 0
                if buy_condition <= daily_data.fluctuation
                    has_stock[0] = current_capital[0].div(daily_data.price)
                    # div is 整数の商を求める際に使う
                    current_capital[0] = current_capital[0] % daily_data.price
                    # 単元未満株は考慮しないので、余りは現金で保持
                    active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                else
                    active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                end
            elsif buy_condition < 0
                if buy_condition >= daily_data.fluctuation
                    has_stock[0] = current_capital[0].div(daily_data.price)
                    current_capital[0] = current_capital[0] % daily_data.price
                    active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                else
                    active_trade_log[:data].update({daily_data.date.strftime("%Y-%m-%d") => check_valuation(has_stock[0], daily_data.price, current_capital[0]).round})
                end
            end
            end
            
            
            if i == (stockdata.length - 1)
            # ループの最後に最終評価額の算出を実行
                valuation = []
                profit_and_loss = []
                interest = []
                annual_interest = []

                (0..1).each do |n|
                    valuation << check_valuation(has_stock[n], daily_data.price, current_capital[n])
                    profit_and_loss << valuation[n] - start_capital
                    interest << (valuation[n] / start_capital) - 1
                    annual_interest << (interest[n] / (stockdata.last.date - stockdata.first.date + 1)) * 365.2425
                end
                return valuation, profit_and_loss, interest, valuation_log, start_capital, annual_interest
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