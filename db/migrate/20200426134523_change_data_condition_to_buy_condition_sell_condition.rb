class ChangeDataConditionToBuyConditionSellCondition < ActiveRecord::Migration[6.0]
  def change
    change_column :conditions, :buy_condition, :decimal,  precision: 5, scale: 2
    change_column :conditions, :sell_condition, :decimal,  precision: 5, scale: 2
  end
end
