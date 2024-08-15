class QuizzesController < ApplicationController
  before_action :authenticate_user!, only: [:my_quizzes]
  before_action :set_quiz, only: %i[show edit update destroy results do_quiz submit_quiz take submit_results quiz_finished confirm_delete]

  # GET /quizzes or /quizzes.json
  def index
    @quizzes = Quiz.all  # Retrieve all quizzes, not just those owned by the current user
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
  end

  def new
    @quiz = current_user.quizzes.build
    build_questions_with_answers(@quiz, initialize_if_empty: true)
  end

  def edit
    build_questions_with_answers(@quiz, initialize_if_empty: true)
  end

  def set_quiz
    @quiz = Quiz.find_by(id: params[:id])
    if @quiz.nil?
      redirect_to quizzes_path, alert: 'Quiz not found.'
    end
  end

  # POST /quizzes or /quizzes.json
  def create
      @quiz = Quiz.new(quiz_params.merge(user: current_user))
    if @quiz.save
      redirect_to @quiz, notice: "Quiz was successfully created."
    else
      # Log the validation errors
      Rails.logger.debug @quiz.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quizzes/1 or /quizzes/1.json
  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: "Quiz was successfully updated."
    else
      build_questions_with_answers(@quiz, initialize_if_empty: false)
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_delete
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    if @quiz.destroy
      redirect_to my_quizzes_path, notice: "Quiz was successfully deleted."
    else
      redirect_to my_quizzes_path, alert: "Quiz could not be deleted."
    end
  end

  def do_quiz
    @questions = @quiz.questions.includes(:answers)
  end

  def submit_quiz
    correct_answers = 0
    total_questions = @quiz.questions.count
  
    params.each do |answer, value|
      if answer.start_with?('question_')
        question_id = answer.split('_').last
        question = Question.find(question_id)
        answer = Answer.find(value)
        correct_answers += 1 if answer.correct
      end
    end
  
    score = (correct_answers.to_f / total_questions * 100).round
  
    user_score = UserScore.create(user: current_user, quiz: @quiz, score: score)
  
    redirect_to result_quiz_path(@quiz, score: score)
  
  end

  # GET /quizzes/:id/take
  def take
    # If the user has already taken the quiz, redirect them with a message
    if @user_already_taken_quiz
      redirect_to quiz_path(@quiz), alert: "You have already taken this quiz."
    else
      @questions = @quiz.questions.includes(:answers)
    end
  end


  # POST /quizzes/:id/submit_results
  def submit_results

    # Only allow submission if the user hasn't taken the quiz yet
    if @user_already_taken_quiz
      redirect_to quiz_path(@quiz), alert: "You cannot submit results for this quiz because you've already completed it."
      return
    end
    user_answers = []
    correct_answers = []
    
    params[:answers]&.each do |question_id, answer_id|
      question = Question.find_by(id: question_id)
      
      if question
        selected_answer = Answer.find_by(id: answer_id)
        correct_answer = question.answers.find_by(correct: true)
        
        user_answers << { question: question, selected_answer: selected_answer }
        correct_answers << { question: question, correct_answer: correct_answer } if correct_answer
      end
    end
  
    score = calculate_score
    UserScore.create(user: current_user, quiz: @quiz, score: score)
  
    redirect_to quiz_finished_quiz_path(@quiz, score: score, user_answers: user_answers, correct_answers: correct_answers)
  end
  
  def quiz_finished
    @score = params[:score]
  
    # Initialize hashes to store the objects instead of IDs
    @user_answers = {}
    @correct_answers = {}
  
    # Ensure params[:user_answers] and params[:correct_answers] are not nil
    params[:user_answers]&.each do |question_id, answer_id|
      question = Question.find_by(id: question_id)
      selected_answer = Answer.find_by(id: answer_id)
  
      if question
        @user_answers[question] = selected_answer
      end
    end
  
    params[:correct_answers]&.each do |question_id, correct_answer_id|
      question = Question.find_by(id: question_id)
      correct_answer = Answer.find_by(id: correct_answer_id)
  
      if question
        @correct_answers[question] = correct_answer
      end
    end
  end

  # GET /quizzes/:id/results
  def results
    @score = params[:score]
    @user_score = current_user.user_scores.find_by(quiz: @quiz)

    if @score.nil?
      flash[:alert] = "No score available. Please take the quiz first."
      redirect_to take_quiz_path(@quiz) and return
    end
  end

  def my_quizzes
    @quizzes = Quiz.where(user_id: current_user.id).distinct
  end

  def search
    if params[:query].present?
      @quizzes = Quiz.where("title LIKE ?", "%#{params[:query]}%")
    else
      @quizzes = Quiz.none
    end
  end

  def submit_feedback
    @quiz = Quiz.find(params[:id])
    @feedback = @quiz.feedbacks.new(feedback_params)
    @feedback.user = current_user
  
    if @feedback.save
      redirect_to user_profile_path, notice: 'Feedback submitted successfully.'
    else
      redirect_to quiz_finished_quiz_path(@quiz, score: params[:score], error: @feedback.errors.full_messages.to_sentence)
    end
  end

  private

    def check_user_participation
      @user_already_taken_quiz = UserScore.exists?(user: current_user, quiz: @quiz)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])  # Find the quiz by ID without restricting to the current user
    end
  
    def quiz_params
      params.require(:quiz).permit(
        :title, 
        :description,
        questions_attributes: [
          :id, :question_text, :_destroy,
          answers_attributes: [:id, :answer_text, :correct, :_destroy]
        ]
      )
    end

    def feedback_params
      params.require(:feedback).permit(:content)
    end

    def calculate_score
      correct_answers = 0
      total_questions = @quiz.questions.count
  
      params[:answers]&.each do |question_id, answer_id|
        question = Question.find(question_id)
        answer = Answer.find(answer_id)
        correct_answers += 1 if answer.correct
      end
  
      (correct_answers.to_f / total_questions * 100).round
    end

    def build_questions_with_answers(quiz, initialize_if_empty: false)
      if initialize_if_empty && quiz.questions.empty?
        question = quiz.questions.build
        4.times { question.answers.build }
      else
        quiz.questions.each do |question|
          4.times { question.answers.build } while question.answers.size < 4
        end
      end
    end
  
  end
