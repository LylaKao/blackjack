class GamesController < ApplicationController
  before_action :fetch_current_game

  def index
    redirect_to new_user_session_path if current_user.nil?

    max_players = @game.settings.max_players
    @players = (1..max_players).each_with_object({}) do |n, hash|
      user_game = @game.user_games.includes(:user).find_by(seat_id: n)
      is_current_user = current_user && user_game&.user_id == current_user.id
      @current_user_seat_id = n if is_current_user
      hash[n] = UserGameDecorator.new(user_game, is_current_user) if user_game
    end

    @dealer_cards = @game.cards.decorate
    @dealer_score = @game.dealer_score
  end

  def start_game
    @game.start_game
    redirect_to root_path
  end

  def end_game
    @game.end_game
    redirect_to root_path
  end

  def restart_game
    Game.create_new_game
    redirect_to root_path
  end

  private

  def fetch_current_game
    @game = Game.create_or_get_current_game
  end
end
