class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :answer_id, presence: true
  validates_uniqueness_of :question_id, scope: :user_id, message: "has already been answered by this user"

  scope :finalized, -> { where(draft: false) }
  scope :drafts, -> { where(draft: true) }
end