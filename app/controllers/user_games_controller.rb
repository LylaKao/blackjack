class UserGamesController < ApplicationController
  before_action :fetch_current_game

  def new
    @min_bet = @game.settings.min_bet
    @seat_id = user_game_params[:seat_id]

    # Show bet modal
    respond_to do |format|
      format.js { render 'new' }
    end
  end

  def create
    seat_id = user_game_params[:seat_id]
    bet = user_game_params[:bet].to_i

    if @game.add_user(current_user, seat_id, bet)
      flash[:notice] = "You have successfully joined the game! Your seat is No.#{seat_id} "
    end
  rescue => e
    flash[:alert] = e.message
  ensure
    redirect_to root_path
  end

  def destroy
    user_id = user_game_params[:user_id].to_i
    byebug
    if @game.remove_user(user_id)
      flash[:notice] = "You have successfully left the game!"
    end
  rescue => e
    flash[:alert] = e.message
  ensure
    redirect_to root_path
  end


  private

  def fetch_current_game
    @game = Game.create_or_get_current_game if params[:game_id].nil?
  end

  def user_game_params
    params.permit(:user_id, :game_id, :seat_id, :bet)
  end
end
