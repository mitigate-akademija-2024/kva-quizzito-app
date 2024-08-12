class HighscoresController < ApplicationController
  def index
    @highscores = Score.includes(:user, :quiz).order(score: :desc).limit(10)
  end
end