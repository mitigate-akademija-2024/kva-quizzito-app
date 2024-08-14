class UsersController < ApplicationController
  before_action :authenticate_user!  # Ensure the user is logged in

  def profile
    @user = current_user
    @quizzes = @user.quizzes
    @scores = @user.user_scores.includes(:quiz)
  end
end