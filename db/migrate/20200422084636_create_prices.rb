class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.references :stock, null: false, foreign_key: true
      t.date :date
      t.float :price
      t.float :fluctuation

      t.timestamps
    end
  end
end
