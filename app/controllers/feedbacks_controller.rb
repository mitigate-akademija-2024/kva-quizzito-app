class FeedbacksController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @quiz = Quiz.find(params[:quiz_id])
    @feedback = @quiz.feedbacks.new(feedback_params)
    @feedback.user = current_user

    if @feedback.save
      redirect_to feedback_submitted_path
    else
      redirect_to quiz_finished_quiz_path(@quiz), alert: 'Your feedback could not be saved.'
    end
  end

  def index
    @feedbacks = current_user.feedbacks.includes(:quiz)
  end


  def feedback_submitted
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content)
  end
end