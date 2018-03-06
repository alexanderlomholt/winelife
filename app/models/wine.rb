class Wine < ApplicationRecord
	belongs_to: :store
	belongs_to: :user
	has_many: :stock, dependent: :destroy

	validates :name, presence: true 
	validates :price, presence: true
end
