class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :scores, dependent: :destroy
  has_many :quizzes, through: :scores
  has_many :feedbacks, dependent: :destroy
  has_many :user_answers, dependent: :destroy

  def total_score
    scores.sum(:score)
  end

  def has_score?(quiz)
    scores.exists?(quiz_id: quiz.id)
  end
end
