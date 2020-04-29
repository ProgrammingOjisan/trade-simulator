FactoryBot.define do
  factory :condition do
    stock { nil }
    buy_condition { 1.5 }
    sell_condition { 1.5 }
    duration { 1 }
    interest { 1.5 }
  end
end
