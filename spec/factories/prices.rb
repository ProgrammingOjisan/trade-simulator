FactoryBot.define do
  factory :price do
    stock_id { nil }
    date { "2020-04-22" }
    price { 1.5 }
    fluctuation { 1.5 }
  end
end
