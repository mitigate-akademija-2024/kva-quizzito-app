class Question < ApplicationRecord
  belongs_to :quiz

  # Ensure there is no reference to `content`
  validates :question_text, presence: true
end