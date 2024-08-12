class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, inverse_of: :question, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :question_text, presence: true
  validate :must_have_four_answers

  private

  def must_have_four_answers
    errors.add(:base, "Each question must have exactly 4 answers") unless answers.size == 4
  end
  
end