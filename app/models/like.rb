class Like < ApplicationRecord
  belongs_to :user
  belongs_to :wine

  validates :wine, uniqueness: { scope: :user }
end
