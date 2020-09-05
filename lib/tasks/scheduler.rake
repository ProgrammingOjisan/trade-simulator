desc "This task is called by the Heroku scheduler add-on"
task :fetch_stock_info => :environment do
    puts "fetch_stock_info"
    puts "it works."
    
    benchmark_result = Benchmark.realtime do
        Stock.all.each do |stock|
            puts "before price count" 
                puts Price.where(stock_id: stock.id).count 
                logger = Logger.new("./api.log")
                
                base_url = "https://www.alphavantage.co/query?"
                my_api_key = Rails.application.credentials.AlphaVantage[:access_key_id]
                price_type = "TIME_SERIES_DAILY"
                my_symbol = stock.code
                Price.where(stock_id: stock.id).present? ? output_size = "compact" : output_size = "full"
        
                params = URI.encode_www_form({function: price_type, symbol: my_symbol, outputsize: output_size, apikey: my_api_key})
                uri = URI.parse(base_url + params)
                begin
                    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |https|
                        https.open_timeout = 3
                        https.read_timeout = 10
                        https.get(uri.request_uri)
                    end
                    
                    case response
                    when Net::HTTPSuccess
                       api_result = JSON.parse(response.body)
            
                    when Net::HTTPRedirection
                        logger.warn("Redirection: code=#{response.code} messsage=#{response.message}")
                    else
                        logger.warn("Redirection: code=#{response.code} messsage=#{response.message}")
                    end
                    
                    rescue IOError => e
                        logger.error(e.message)
                        logger.error(e.message)
                    rescue JSON::ParserError => e
                        logger.error(e.message)
                    rescue => e
                        logger.error(e.message)
                end
                
                
                # DBへの保存処理
                prices = api_result["Time Series (Daily)"]
                prices.reverse_each do |key, price|
                    Price.find_or_create_by(stock_id: stock.id, date: Time.parse(key), price: price.dig("4. close"))
                end
                puts "after price count" 
                puts Price.where(stock_id: stock.id).count 
            end
        end
    puts "処理時間:"
    puts benchmark_result
end

task :recalculate_interest => :environment do
    include TradeSimulation

    puts "recalculate_interest"
    puts "it works."
    benchmark_result = Benchmark.realtime do

        Condition.all.each do |condition|
            simulation_condition = [condition[:stock_id], condition[:buy_condition], condition[:sell_condition], condition[:duration]]
            simulation_results = trade_simulation(*simulation_condition)
            condition.interest = simulation_results[2][0]
            condition.save
        end

    end
    puts "処理時間:"
    puts benchmark_result
end
