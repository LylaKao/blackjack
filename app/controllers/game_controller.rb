class GameController < ApplicationController
  before_action :fetch_current_game

  def index
    max_players = @game.settings.max_players
    @players = (1..max_players).each_with_object({}) do |n, hash|
      user_game = @game.user_games.includes(:user).find_by(seat_id: n)
      is_current_user = user_game&.user_id == current_user.id
      @current_user_seat_id = n if is_current_user
      hash[n] = UserGameDecorator.new(user_game, is_current_user) if user_game
    end
  end

  private

  def fetch_current_game
    @game = Game.create_or_get_current_game
  end
end
