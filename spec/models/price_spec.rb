require 'rails_helper'

# テスト実行時にはprice.rbのset_fluctuationをPrivateメソッドから外す

RSpec.describe Price, type: :model do
    describe "validation" do
        before(:each) do
            Stock.create(id: 1, name: "testnikkei", code: "000001")
            @completely_filled_price = Price.new(stock_id: 1, date: "20200401", price: 10000.0, fluctuation: 0.5)
        end
        
        it "is invalid without date" do
            @completely_filled_price.date = nil
            @completely_filled_price.valid?
            expect(@completely_filled_price.errors[:date]).to include("can't be blank")
        end
        
        it "is invalid without price" do
            @completely_filled_price.price = nil
            @completely_filled_price.valid?
            expect(@completely_filled_price.errors[:price]).to include("can't be blank")
        end
        
        it "is invalid except that price is numericality" do
            @completely_filled_price.price = "characters"
            @completely_filled_price.valid?
            expect(@completely_filled_price.errors[:price]).to include("is not a number")
        end
        
        it "is valid without fluctuation" do
            @completely_filled_price.fluctuation = nil
            expect(@completely_filled_price).to be_valid
        end
        it "is invalid except that fluctuation is numericality" do
            @completely_filled_price.fluctuation = "characters"
            @completely_filled_price.valid?
            expect(@completely_filled_price.errors[:fluctuation]).to include("is not a number")
        end
    end

    describe "setting a fluctuation" do

        before(:each) do
            Stock.create(id: 1,name: "testnikkei", code: "000001")
            @first_price = Price.create(id: 1, stock_id: 1, date: "20200401", price: 1.0, fluctuation: nil)
            @second_price = Price.create(id: 2, stock_id: 1, date: "20200402", price: 2.0, fluctuation: nil)
            @setted_price = Price.create(id: 3, stock_id: 1, date: "20200403", price: 3.0, fluctuation: 55555.5)
        end

        context "when the first record in that stock_id is created" do 
            it "doesn't change a fluctuation" do
                @first_price.set_fluctuation
                expect(@first_price.fluctuation).to eq nil
            end
        end

        context "when a fluctuation is already existed" do 
            it "doesn't change a fluctuation" do
                @setted_price.set_fluctuation
                expect(@setted_price.fluctuation).to eq 55555.5
            end
        end

        context "when a fluctuiation is blank & the second and following record in that stock_id is created" do
            it "set a fluctuation" do
                @second_price.set_fluctuation
                expect(@second_price.fluctuation).to eq 1.0
            end
        end
    end
end