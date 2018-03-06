class Store < ApplicationRecord
	has_many: :wine
	has_many: :stock
	has_many: :user

	validates :name, presence: true, uniqueness: true
	validates :address, presence: true, uniqueness: true 
end
