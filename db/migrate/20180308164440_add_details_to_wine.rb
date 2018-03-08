class AddDetailsToWine < ActiveRecord::Migration[5.1]
  def change
    add_column :wines, :tasting_note, :string
    add_column :wines, :serving_temperature, :string
    add_column :wines, :alcohol_percent, :string
  end
end
