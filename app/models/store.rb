class Store < ApplicationRecord
	has_many: :wines, through: :stocks
	has_many: :stocks


	validates :name, presence: true, uniqueness: true
	validates :address, presence: true, uniqueness: true 
end
