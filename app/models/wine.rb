class Wine < ApplicationRecord
	validates :name, presence: true
	validates :price, presence: true

  scope :red, -> { where(colour: 'Red wine') }
  scope :white, -> { where(colour: 'White wine') }
  scope :rose, -> { where(colour: 'Rosé') }

  scope :meat, -> { where(pairs_with_meat: true) }
  scope :fish, -> { where(pairs_with_seafood: true) }
  scope :cheese, -> { where(pairs_with_cheese: true) }

  scope :budget_1, -> { where('price <= 15') }
  scope :budget_2, -> { where('price > 15').where('price <= 25') }
  scope :budget_3, -> { where('price > 25') }

  has_many :dashboard
end
