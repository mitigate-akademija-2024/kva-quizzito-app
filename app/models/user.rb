class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable
         
         has_many :quizzes, dependent: :destroy
         has_many :scores
         has_many :quizzes, through: :scores

end