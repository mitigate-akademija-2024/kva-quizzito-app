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

  # POST /quizzes or /quizzes.json
  def create
    @quiz = current_user.quizzes.build(quiz_params)

    if @quiz.save
      redirect_to @quiz, notice: "Quiz was successfully created."
    else
      build_questions_with_answers(@quiz, initialize_if_empty: false)
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
    @questions = @quiz.questions.includes(:answers)
  end

  # POST /quizzes/:id/submit_results
  def submit_results
    score = calculate_score
    UserScore.create(user: current_user, quiz: @quiz, score: score)
  
    redirect_to quiz_finished_quiz_path(@quiz, score: score)
  end

  # GET /quizzes/:id/finished
  def quiz_finished
    @score = params[:score]
    @quiz = Quiz.find(params[:id])
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
    @quizzes = current_user.quizzes
  end
  
  def highscores
    @highscores = User.joins(:user_scores)
                      .select('users.*, SUM(user_scores.score) AS total_score')
                      .group('users.id')
                      .order('total_score DESC')
                      .limit(10)
  end

  def quiz_highscores
    @quiz = Quiz.find(params[:id])
    @highscores = @quiz.user_scores.order(score: :desc).limit(10)
  end

  def search
    if params[:query].present?
      @quizzes = Quiz.where("title LIKE ?", "%#{params[:query]}%")
    else
      @quizzes = Quiz.none
    end
  end

  private
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

