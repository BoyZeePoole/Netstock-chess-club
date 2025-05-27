class RankService
  def initialize(match)
    @match = match
    @player1 = match.player_one
    @player2 = match.player_two
  end

  def apply
    return if @player1.id == @player2.id
    handle_game_played([@player1, @player2])
    higher, lower = [@player1, @player2].sort_by(&:current_rank)

    case @match.result
    when 0
      handle_draw(higher, lower)
    when 1
      handle_win(@player1, @player2)
    when 2
      handle_win(@player2, @player1)
    else
      # type code here
    end

  end

  private

  def handle_game_played(players)
    players.each do |player|
      player.no_of_games_played += 1
    end
    players.each(&:save!)
  end

  def handle_draw(higher, lower)
    return if (higher.current_rank - lower.current_rank).abs == 1
    new_rank = lower.current_rank - 1
    # lower.current_rank -= 1
    # update_ranks([lower])
     promote_player(lower, new_rank)
  end

  def handle_win(winner, loser)
    if winner.current_rank < loser.current_rank
      # Higher-ranked player won, no change
      return
    end

    # Lower-ranked player won
    diff = (winner.current_rank - loser.current_rank)
    new_rank = winner.current_rank - (diff / 2.0).ceil

    demote_player(loser)
    promote_player(winner, new_rank)
  end

  def demote_player(player)
    Member.where("current_rank = ?", player.current_rank + 1).update_all("current_rank = current_rank - 1")
    player.current_rank += 1
    player.save!
  end

  def promote_player(player, new_rank)
    Member.where("current_rank >= ? AND current_rank < ?", new_rank, player.current_rank).update_all("current_rank = current_rank + 1")
    player.update!(current_rank: new_rank)
  end

  def update_ranks(players)
    players.each(&:save!)
  end

end