class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  validates :content, presence: true
end