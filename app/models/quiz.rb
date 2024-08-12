class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, inverse_of: :quiz, dependent: :destroy
  has_many :scores
  has_many :users, through: :scores
  accepts_nested_attributes_for :questions, allow_destroy: true

end
