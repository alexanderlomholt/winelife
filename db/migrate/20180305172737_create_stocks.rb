class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.references :store, foreign_key: true
      t.references :wine, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
