class UserAnswersController < ApplicationController
    before_action :authenticate_user!  # Ensure the user is logged in before answering
  
    def create
      @question = Question.find(params[:question_id])
      @user_answer = @question.user_answers.build(user_answer_params)
      @user_answer.user = current_user
  
      if @user_answer.save
        redirect_to quiz_path(@question.quiz), notice: 'Your answer has been submitted.'
      else
        redirect_to quiz_path(@question.quiz), alert: 'There was an issue submitting your answer.'
      end
    end
  
    private
  
    def user_answer_params
      params.require(:user_answer).permit(:answer_id)
    end
  end