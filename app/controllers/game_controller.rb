class GameController < ApplicationController
  before_action :fetch_current_game

  def index

  end


  private

  def fetch_current_game
    @game = Game.create_or_get_current_game
  end
end
