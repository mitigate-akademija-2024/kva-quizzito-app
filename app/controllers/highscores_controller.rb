require 'csv'

class HighscoresController < ApplicationController
  def index
    @highscores = User.joins(:scores)
                      .select('users.*, SUM(scores.score) AS total_score')
                      .group('users.id')
                      .order('total_score DESC')
                      .limit(10)
  end

  def export_csv
    @highscores = User.joins(:scores)
                      .select('users.*, SUM(scores.score) AS total_score')
                      .group('users.id')
                      .order('total_score DESC')
                      .limit(10)

    respond_to do |format|
      format.html # This allows the action to be rendered in HTML if needed
      format.csv { send_data generate_csv(@highscores), filename: "highscores-#{Date.today}.csv" }
    end
  end

  private

  def generate_csv(highscores)
    CSV.generate(headers: true) do |csv|
      csv << ['Username', 'Email', 'Total Score']
      
      highscores.each do |user|
        csv << [user.username || user.email, user.email, user.total_score]
      end
    end
  end
end
