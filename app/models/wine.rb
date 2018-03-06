class Wine < ApplicationRecord
	belongs_to: :store
	has_many: :stock

	
end
