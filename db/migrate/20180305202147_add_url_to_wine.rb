class AddUrlToWine < ActiveRecord::Migration[5.1]
  def change
    add_column :wines, :url, :string
  end
end
