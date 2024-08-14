class HighscoresController < ApplicationController
  def index
    @top_users = User
                  .joins(:scores)
                  .select('users.*, SUM(scores.score) as total_score')
                  .group('users.id')
                  .order('total_score DESC')
                  .limit(10)
  end
end