class CreateConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :conditions do |t|
      t.references :stock, null: false, foreign_key: true
      t.float :buy_condition
      t.float :sell_condition
      t.integer :duration
      t.float :interest

      t.timestamps
    end
  end
end
