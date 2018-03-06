class AddStoreIdentifierAndLocationIdToStores < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :store_identifier, :integer
    add_column :stores, :location_id, :integer
    remove_column :stores, :saq_store_id
  end
end
