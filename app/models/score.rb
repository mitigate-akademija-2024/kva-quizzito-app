class Score < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  validates :score, presence: true, numericality: { only_integer: true }
end
