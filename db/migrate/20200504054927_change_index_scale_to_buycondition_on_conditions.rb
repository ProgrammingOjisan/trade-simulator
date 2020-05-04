class ChangeIndexScaleToBuyconditionOnConditions < ActiveRecord::Migration[6.0]
  def change
    change_column :conditions, :buy_condition, :decimal,  precision: 10, scale: 3
    change_column :conditions, :sell_condition, :decimal,  precision: 10, scale: 3
  end
end
