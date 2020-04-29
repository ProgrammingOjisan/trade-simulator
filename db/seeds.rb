    (1..20).each do |i|
        User.create(name: "Mr.NO"+i.to_s, email: "seeds"+i.to_s+"@test.com", password: "password"+i.to_s)
    end
    
    Stock.create(name: "NIKKEI225", code: "0001")
    Stock.create(name: "TOPIX", code: "0002")
    Stock.create(name: "MOTHERS", code: "0003")
    
    d = Date.new(2020,4,1)
    (1..90).each do |n|
        price = (n*n*100) % 1000 + 100
        Stock.first.price.create(
            date: d+n,
            price: price
        )
    end

    (1..90).each do |n|
        price = (n*n*50) % 500 + 500
        Stock.find(2).price.create(
            date: d+n,
            price: price
        )
    end

    (1..60).each do |n|
        price = (n*n*30) % 300 + 33
        Stock.find(3).price.create(
            date: d+n,
            price: price
        )
    end
    
    (1..3).each do |i|
        if i % 3 == 1
            n = 1
        elsif i % 3 == 2
            n = 2
        else
            n = 3
        end
        Condition.create(stock_id: n, buy_condition: 0.01, sell_condition: 0.02, duration: 10)
        Condition.create(stock_id: n, buy_condition: -0.01, sell_condition: 0.02, duration: 10)
        Condition.create(stock_id: n, buy_condition: 0.01, sell_condition: -0.02, duration: 10)
        Condition.create(stock_id: n, buy_condition: -0.01, sell_condition: -0.02, duration: 10)
        Condition.create(stock_id: n, buy_condition: 0.01, sell_condition: 0.02, duration: 30)
        Condition.create(stock_id: n, buy_condition: -0.01, sell_condition: 0.02, duration: 30)
        Condition.create(stock_id: n, buy_condition: 0.01, sell_condition: -0.02, duration: 30)
        Condition.create(stock_id: n, buy_condition: -0.01, sell_condition: -0.02, duration: 30)
    end
