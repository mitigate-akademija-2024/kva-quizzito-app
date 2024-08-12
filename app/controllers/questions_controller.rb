class QuestionsController < ApplicationController
  before_action :set_quiz
  before_action :set_question, only: [:edit, :update, :destroy]

  def new
    @question = @quiz.questions.build
  end

  def create
    @question = @quiz.questions.build(question_params)
    if @question.save
      redirect_to @quiz, notice: 'Question added successfully.'
    else
      render :new, alert: 'Failed to add question.'
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @quiz, notice: 'Question updated successfully.'
    else
      render :edit, alert: 'Failed to update question.'
    end
  end

  def destroy
    @question.destroy
    redirect_to @quiz, notice: 'Question deleted successfully.'
  end

  def submit_answers
    @quiz = Quiz.find(params[:quiz_id])
    @user_answers = []

    params[:answers].each do |question_id, answer_id|
      user_answer = UserAnswer.create(
        user: current_user,
        question_id: question_id,
        answer_id: answer_id
      )
      @user_answers << user_answer
    end

    redirect_to results_quiz_path(@quiz), notice: 'Your answers have been submitted successfully.'
  end

  def results
    @quiz = Quiz.find(params[:id])
    @user_answers = current_user.user_answers.where(question: @quiz.questions)
    @correct_answers_count = @user_answers.select { |ua| ua.answer.correct }.count
  end



  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = @quiz.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_text)
  end
end
