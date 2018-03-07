class Store < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :address, presence: true, uniqueness: true

  reverse_geocoded_by :latitude, :longitude
end
