class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :code

      t.timestamps
      t.index :name, unique: true
      t.index :code, unique: true
    end
  end
end
