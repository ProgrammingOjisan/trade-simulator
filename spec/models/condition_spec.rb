require 'rails_helper'
include TradeSimulation

RSpec.describe Condition, type: :model do
    
    describe "trade simulation" do
        before do
            @nikkei225 = Stock.create(id: 1, name: "Nikkei225", code: "0001")
            d = Date.new(1993, 5, 1)
            (1..10).each do |n|
                price = (n*n*100) % 1000 + 100
                @nikkei225.price.create(
                    date: (d + n),
                    price: price
                )
            end
        end
    
        context "when buy_condition is +10% and sell_c is +30%, " do
            it "returns 2857100 valuation" do
                stock_id = 1
                buy_condition = 0.1
                sell_condition = 0.3
                duration = 10
                results = trade_simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results[0][0]).to eq 2857100
            end            
        end
    
        context "when buy_condition is +30% and sell_c is -30%, " do
            it "returns 700000 valuation" do
                stock_id = 1
                buy_condition = 0.3
                sell_condition = -0.3
                duration = 10
                results = trade_simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results[0][0]).to eq 700000
            end            
        end
    
        context "when buy_condition is -20% and sell_c is +30%, " do
            it "returns 286000 valuation" do
                stock_id = 1
                buy_condition = -0.2
                sell_condition = 0.3
                duration = 10
                results = trade_simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results[0][0]).to eq 286000
            end            
        end
    
        context "when buy_condition is -30% and sell_c is -50%, " do
            it "returns 357200 valuation" do
                stock_id = 1
                buy_condition = -0.3
                sell_condition = -0.5
                duration = 10
                results = trade_simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results[0][0]).to eq 357200
            end            
        end
    
        context "when duration is 20, " do
            it "returns 80000 valuation" do
            d = Date.new(1993, 5, 1)
                (11..20).each do |n|
                    price = (n*n*100) % 1000 + 100
                    @nikkei225.price.create(
                        date: (d + n),
                        price: price
                    )
                end
    
                stock_id = 1
                buy_condition = 0.4
                sell_condition = 1.0
                duration = 20
                results = trade_simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results[0][0]).to eq 80000
            end            
        end
    
        context "when doesn't match any conditions, " do
            it "returns 1000000 valuation" do
        
                stock_id = 1
                buy_condition = 50000.0
                sell_condition = -50000.0
                duration = 10
                results = trade_simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results[0][0]).to eq 1000000
            end            
        end
    
        context "when selected stock_id isn't exist, " do
            it "returns error message included -There are not any Stock Prices-" do
                stock_id = "123456"
                buy_condition = 1.5
                sell_condition = -0.6
                duration = 10
                
                e = trade_simulation(stock_id,buy_condition,sell_condition,duration)
                expect(e).to include "There are not any Stock Prices"
            end
        end
    end
end
