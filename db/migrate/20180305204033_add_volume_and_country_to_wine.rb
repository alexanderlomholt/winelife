class AddVolumeAndCountryToWine < ActiveRecord::Migration[5.1]
  def change
    add_column :wines, :volume, :string
    add_column :wines, :country, :string
  end
end
