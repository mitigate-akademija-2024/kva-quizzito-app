require 'csv'

class HighscoresController < ApplicationController
  def index
    @top_users = User.joins(:scores)
                     .select('users.*, SUM(scores.score) AS total_score')
                     .group('users.id')
                     .order('total_score DESC')
                     .limit(10)
  end

  def export_csv
    @top_users = User.joins(:scores)
                     .select('users.*, SUM(scores.score) AS total_score')
                     .group('users.id')
                     .order('total_score DESC')
                     .limit(10)

    respond_to do |format|
      format.csv { send_data generate_csv(@top_users), filename: "highscores-#{Date.today}.csv" }
    end
  end

  def quiz_highscores
    @quiz = Quiz.find(params[:id])
    @highscores = @quiz.scores.joins(:user)
                             .select('users.username, users.email, scores.score')
                             .order('scores.score DESC')
                             .limit(10)
  end

  def export_highscores_csv
    @quiz = Quiz.find(params[:id])
    @highscores = @quiz.scores.joins(:user)
                             .select('users.username, users.email, scores.score')
                             .order('scores.score DESC')
                             .limit(10)

    respond_to do |format|
      format.csv { send_data generate_csv(@highscores), filename: "quiz-#{@quiz.id}-highscores-#{Date.today}.csv" }
    end
  end

  private

  def generate_csv(highscores)
    CSV.generate(headers: true) do |csv|
      csv << ['Username', 'Email', 'Score']

      highscores.each do |entry|
        csv << [entry.username || entry.email, entry.email, entry.score]
      end
    end
  end
end
