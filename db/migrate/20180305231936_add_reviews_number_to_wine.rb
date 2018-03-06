class AddReviewsNumberToWine < ActiveRecord::Migration[5.1]
  def change
    add_column :wines, :reviews_number, :integer
  end
end
