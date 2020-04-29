class ChangeDataConditionToInterest < ActiveRecord::Migration[6.0]
  def change
        change_column :conditions, :interest, :decimal

  end
end
