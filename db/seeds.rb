benchmark_result = Benchmark.realtime do
# User sample
User.create(name: "Guest", email: "guest@login.com", password: "guestlogin")
user_name = [
        "Aneesah",
        "Karson",
        "Usman",
        "Deacon",
        "Chase",
        "Shreya",
        "Tudor",
        "Husnain",
        "Dianne",
        "AmyLeigh",
        "Daniyal",
        "Anish",
        "Nadeem",
        "April",
        "Bonita",
        "Ellouise",
        "Emily-Rose",
        "Phyllis",
        "Lennon",
        "Roshan"
    ]
user_name.each_with_index do |name, i|    
    User.create(name: (name + "_" + ((( i + 1 ) * 11 + 3) % 100).to_s), email: "user"+i.to_s+"@test.com", password: "password"+i.to_s)  
end

# Stock sample
stock_name = ["NIKKEI225", "TOPIX", "MOTHERS", "NF日経レバ"]
stock_code = ["1321.TOK", "1306.T", "2516.T", "1570.T"]
stock_name.each_with_index do |name, i|
    Stock.create(name: name, code: stock_code[i])
end

Stock.all.each do |stock|
    logger = Logger.new("./api.log")
    
    base_url = "https://www.alphavantage.co/query?"
    my_api_key = "LODEE8NFTIT9TIKT"
    price_type = "TIME_SERIES_DAILY"
    my_symbol = stock.code
    output_size = "full"

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

        # 実行当日分データは時間帯により終値ではなく日中の価額になる場合があるので取得せずスキップ
        break if key == Date.today.strftime("%Y-%m-%d")

        Price.find_or_create_by(stock_id: stock.id, date: Time.parse(key), price: price.dig("4. close"))
    end
end


# Condition sample
Stock.all.each_with_index do |stock, i|

    price_length = Price.where(stock_id: stock.id).length
    if price_length >= 245*20
        duration = 20
    elsif price_length >= 245*10
        duration = 10
    elsif price_length >= 245*5
        duration = 5
    elsif price_length >= 245*3
        duration = 3
    elsif price_length >= 245*2
        duration = 2
    else
        duration = 1
    end

    5.times do |j|
        5.times do |k|
            Condition.create(stock_id: i+1, buy_condition: 0.005*(i+1), sell_condition: 0.005*(k+1), duration: duration)
            Condition.create(stock_id: i+1, buy_condition: -0.005*(i+1), sell_condition: 0.005*(k+1), duration: duration)
            Condition.create(stock_id: i+1, buy_condition: 0.005*(i+1), sell_condition: -0.005*(k+1), duration: duration)
            Condition.create(stock_id: i+1, buy_condition: -0.005*(i+1), sell_condition: -0.005*(k+1), duration: duration)
        end    
    end    
end
# Favorite sample
user_name.each_with_index do |name, i|
    (1..Condition.all.length).each do |n|
        if n % (i % 10 + 3) == 0
            User.find( i + 1 ).favorites.create(condition_id: n)
        end
    end
end
end

puts "create sample #{benchmark_result}s"