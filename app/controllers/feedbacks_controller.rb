class FeedbacksController < ApplicationController
    before_action :authenticate_user!
  
    

    def create
      @quiz = Quiz.find(params[:quiz_id])
      @feedback = @quiz.feedbacks.new(feedback_params)
      @feedback.user = current_user
  
      if @feedback.save
        redirect_to @quiz, notice: 'Thank you for your feedback!'
      else
        redirect_to @quiz, alert: 'Your feedback could not be saved.'
      end
    end

    def index
        @feedbacks = current_user.feedbacks.includes(:quiz)
    end
  
    private
  
    def feedback_params
      params.require(:feedback).permit(:content)
    end
  end
  