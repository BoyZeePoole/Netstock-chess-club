class AddDefaultValueForCurrentRankAndNoOfGamesPlayed < ActiveRecord::Migration[8.0]
  def change
    change_column :members, :no_of_games_played, :integer, :default => 0
    change_column :members, :current_rank, :integer, :default => 0
  end
end
