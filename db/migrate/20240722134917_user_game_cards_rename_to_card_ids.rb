class UserGameCardsRenameToCardIds < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_games, :cards, :card_ids
  end
end
