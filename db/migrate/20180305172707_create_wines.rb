class CreateWines < ActiveRecord::Migration[5.1]
  def change
    create_table :wines do |t|
      t.string :name
      t.string :variety
      t.string :colour
      t.integer :year
      t.float :rating
      t.float :price
      t.string :photo_url
      t.boolean :pairs_with_meat
      t.boolean :pairs_with_seafood
      t.boolean :pairs_with_cheese

      t.timestamps
    end
  end
end
