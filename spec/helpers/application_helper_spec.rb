require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
    
    describe "trade simulation" do
        before do
            @nikkei225 = Stock.create(id: 1,name: "Nikkei225", code: "0001")
            (1..10).each do |n|
                price = (n*n*100) % 1000 + 100
                @nikkei225.price.create(
                    date: "20200401",
                    price: price
                )
            end
        end
    
        context "when buy_condition is +10% and sell_c is +30%, " do
            it "returns 285500 valuation" do
                stock_id = 1
                buy_condition = 0.1
                sell_condition = 0.3
                duration = 10
                results = simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results).to eq [285500, 185500, 2.855]
            end            
        end
    
        context "when buy_condition is +30% and sell_c is -30%, " do
            it "returns 70000 valuation" do
                stock_id = 1
                buy_condition = 0.3
                sell_condition = -0.3
                duration = 10
                results = simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results).to eq [70000, -30000, 0.7]
            end            
        end
    
        context "when buy_condition is -20% and sell_c is +30%, " do
            it "returns 28600 valuation" do
                stock_id = 1
                buy_condition = -0.2
                sell_condition = 0.3
                duration = 10
                results = simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results).to eq [28600, -71400, 0.286]
            end            
        end
    
        context "when buy_condition is -30% and sell_c is -50%, " do
            it "returns 285500 valuation" do
                stock_id = 1
                buy_condition = -0.3
                sell_condition = -0.5
                duration = 10
                results = simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results).to eq [35800, -64200, 0.358]
            end            
        end
    
        context "when duration is 20, " do
            it "returns 8000 valuation" do
                (11..20).each do |n|
                    price = (n*n*100) % 1000 + 100
                    @nikkei225.price.create(
                        date: "20200401",
                        price: price
                    )
                end
    
                stock_id = 1
                buy_condition = 0.4
                sell_condition = 1.0
                duration = 20
                results = simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results).to eq [8000, -92000, 0.08]
            end            
        end
    
        context "when doesn't match any conditions, " do
            it "returns 100000 valuation" do
        
                stock_id = 1
                buy_condition = 50000.0
                sell_condition = -50000.0
                duration = 10
                results = simulation(stock_id,buy_condition,sell_condition,duration)
                expect(results[0]).to eq 100000
            end            
        end
    
        context "when selected stock_id isn't exist, " do
            it "returns error message included -couldn't find-" do
                stock_id = "123456"
                buy_condition = 1.5
                sell_condition = -0.6
                duration = 10
                
                expect(simulation(stock_id,buy_condition,sell_condition,duration)).to include "couldn't find"
            end
        end
    end

end