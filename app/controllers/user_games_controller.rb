class UserGamesController < ApplicationController
  before_action :fetch_current_game

  def create
    ActiveRecord::Base.transaction do
      user_game = current_user.user_games.build(game_id: @game.id)
      user_game.bet = user_game_params[:bet]
      user_game.seat_id = user_game_params[:seat_id]
      @game.add_player!(current_user)
      user_game.save!
    end
    redirect_to game_path
  end

  def destroy
    @game.remove_player(current_user)
    redirect_to game_path
  end


  private

  def fetch_current_game
    @game = Game.create_or_get_current_game if params[:game_id].nil?
  end

  def user_game_params
    params.permit(:game_id, :seat_id, :bet)
  end
end
