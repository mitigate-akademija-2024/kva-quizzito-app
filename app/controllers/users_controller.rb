class UsersController < ApplicationController
  before_action :authenticate_user!  # Ensure the user is logged in

  def profile
    @user = current_user
    @quizzes = @user.quizzes
    @scores = @user.user_scores.includes(:quiz)
    @received_feedbacks = Feedback.joins(:quiz).where(quiz: @quizzes)
  end

  def my_feedbacks
    @feedbacks = current_user.feedbacks.includes(:quiz)
  end
  
end