class ChangeIndexScaleToInterestAgain2OnConditions < ActiveRecord::Migration[6.0]
  def change
        change_column :conditions, :interest, :decimal,  precision: 10, scale: 5
  end
end
