class ChangeDataConditionToBuyConditionSellCondition < ActiveRecord::Migration[6.0]
  def change
    change_column :conditions, :buy_condition, :decimal
    change_column :conditions, :sell_condition, :decimal
  end
end
