class AddIndexToCondition < ActiveRecord::Migration[6.0]
  def change
    
    add_index :conditions, [:stock_id, :buy_condition, :sell_condition, :duration], unique: true, name: 'conditions_restrict_index'
    
  end
end
