# User sample
user_name = [
        "Aneesah_Ayala",
        "Karson_Hobbs",
        "Usman_Wright",
        "Deacon_Bernard",
        "Chase_Metcalfe",
        "Shreya_Tanner",
        "Tudor_Mcmillan",
        "Husnain_Salazar",
        "Dianne_Avery",
        "Amy-Leigh_Villanueva",
        "Daniyal_Lowry",
        "Anish_Salter",
        "Nadeem_Hendrix",
        "April_Garner",
        "Bonita_Cooke",
        "Ellouise_Martins",
        "Emily-Rose_Rooney",
        "Phyllis_Webber",
        "Lennon_Garcia",
        "Roshan_Barton"
    ]
user_name.each_with_index do |name, i|    
    User.create(name: (name + ((( i + 1 ) * 11 + 3) % 100).to_s), email: "user"+i.to_s+"@test.com", password: "password"+i.to_s)  
end

# Stock sample
stock_name = ["NIKKEI225", "TOPIX", "MOTHERS"]
stock_name.each_with_index do |name, i|
    Stock.create(name: name, code: "000"+( i + 1).to_s)
end


# Price sample
d = Date.new(2020,4,1)
stock_name.each_with_index do |name, i|
    (1..90).each do |n|
        if n % 7 == 0
            price = ((n*n*-15) % 2000) + (20000 * ( i + 1 ) % 25000) + (n * 15)
        elsif n % 17 == 0
            price = ((n*n*-15) % 2000) + (20000 * ( i + 1 ) % 25000) + (n * 15)
        else
            price = ((n*n*50) % 2000) + (20000 * ( i + 1 ) % 25000) + (n * 15)
        end
        Stock.find( i + 1 ).price.create(
            date: d+n,
            price: price
        )
    end
end

# Condition sample
stock_name.each_with_index do |name, i|
        Condition.create(stock_id: i+1, buy_condition: 0.02, sell_condition: 0.01, duration: 30)
        Condition.create(stock_id: i+1, buy_condition: -0.015, sell_condition: 0.03, duration: 30)
        Condition.create(stock_id: i+1, buy_condition: 0.02, sell_condition: -0.025, duration: 30)
        Condition.create(stock_id: i+1, buy_condition: -0.02, sell_condition: -0.01, duration: 30)
        Condition.create(stock_id: i+1, buy_condition: 0.03, sell_condition: 0.02, duration: 90)
        Condition.create(stock_id: i+1, buy_condition: -0.01, sell_condition: -0.015, duration: 90)
        Condition.create(stock_id: i+1, buy_condition: 0.025, sell_condition: -0.03, duration: 90)
        Condition.create(stock_id: i+1, buy_condition: -0.02, sell_condition: -0.01, duration: 90)
end
