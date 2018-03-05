class AddSaqCodeToWines < ActiveRecord::Migration[5.1]
  def change
    add_column :wines, :saq_code, :integer
  end
end
