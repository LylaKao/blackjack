class UserGameDecorator < Draper::Decorator
  delegate_all

  def initialize(user_game, is_current_user = false)
    super(user_game)
    @is_current_user = is_current_user
  end

  def current_user?
    @is_current_user
  end
end
