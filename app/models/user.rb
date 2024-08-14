class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true, uniqueness: { case_sensitive: false }


  has_many :quizzes, dependent: :destroy
  has_many :user_scores
  has_many :scores, through: :user_scores, source: :quiz
  has_many :feedbacks

  
  def total_score
    scores.sum(:score)
  end

end