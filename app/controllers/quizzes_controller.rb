class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def new
    @quiz = current_user.quizzes.build
    @quiz.questions.build # Initialize at least one question
  end

  def create
    @quiz = current_user.quizzes.build(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: 'Quiz was successfully created.'
    else
      render :new
    end
  end # <-- This 'end' was missing

  def edit
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: 'Quiz was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.'
  end

  def submit_answers
    @quiz = Quiz.find(params[:quiz_id])

    if params[:answers].blank?
      redirect_to quiz_path(@quiz), alert: 'You must select an answer for each question before saving.'
      return
    end

    params[:answers].each do |question_id, answer_id|
      user_answer = current_user.user_answers.find_or_initialize_by(
        question_id: question_id,
        user_id: current_user.id
      )
      user_answer.answer_id = answer_id
      user_answer.draft = params[:finalize].blank?
      user_answer.save
    end

    if params[:finalize].present?
      redirect_to results_quiz_path(@quiz), notice: 'Your answers have been submitted successfully.'
    else
      redirect_to review_quiz_path(@quiz), notice: 'Your answers have been saved. You can review them before final submission.'
    end
  end

  def results
    @quiz = Quiz.find(params[:id])
    @user_answers = current_user.user_answers.where(question: @quiz.questions, draft: false)

    if @user_answers.empty?
      redirect_to quiz_path(@quiz), alert: 'You need to take the quiz before viewing the results.'
      return
    end

    @correct_answers_count = @user_answers.select { |ua| ua.answer.correct }.count
  end

  def reset_answers
    @quiz = Quiz.find(params[:id])
    current_user.user_answers.where(question: @quiz.questions).destroy_all
    redirect_to quiz_path(@quiz), notice: 'Your answers have been reset. You can now start the quiz again.'
  end
  
  def my_quizzes
    @quizzes = current_user.quizzes
  end
  
  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:title, :description, questions_attributes: [:id, :question_text, :_destroy])
  end
end
