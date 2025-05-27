require 'test_helper'

class RankServiceTest < ActiveSupport::TestCase
  def setup
    @player1 = Member.create!(name: 'Player 1', current_rank: 1, no_of_games_played: 0, email_address: 'plaer1@gmail.com', surname: 'One', birthday: '1990-01-01')
    @player2 = Member.create!(name: 'Player 2', current_rank: 2, no_of_games_played: 0, email_address: 'plaer1@gmail.com', surname: 'One', birthday: '1990-01-01')
  end
2
  def build_match(result, player_one: @player1, player_two: @player2)
    Match.create!(player_one: player_one, player_two: player_two, result: result)
  end

  test 'does nothing if same player' do
    match = build_match(1, player_one: @player1, player_two: @player1)
    assert_no_difference -> { @player1.reload.no_of_games_played } do
      RankService.new(match).apply
    end
  end

  test 'draw does not change rank if difference is 1' do
    match = build_match(0)
    assert_no_difference -> { @player1.reload.current_rank } do
      assert_no_difference -> { @player2.reload.current_rank } do
        RankService.new(match).apply
      end
    end
  end

  test 'draw demotes lower if difference > 1' do
    @player2.update!(current_rank: 4)
    match = build_match(0)
    assert_difference -> { @player2.reload.current_rank }, -1 do
      RankService.new(match).apply
    end
  end

  test 'higher ranked player wins, no rank change' do
    match = build_match(1)
    assert_no_difference -> { @player1.reload.current_rank } do
      assert_no_difference -> { @player2.reload.current_rank } do
        RankService.new(match).apply
      end
    end
  end

  test 'lower ranked player wins, ranks adjust' do
    match = build_match(2)
    old_rank1 = @player1.current_rank
    old_rank2 = @player2.current_rank
    RankService.new(match).apply
    @player2.reload
    @player1.reload
    assert @player2.current_rank < old_rank2, 'Winner should be promoted'
    assert @player1.current_rank > old_rank1, 'Loser should be demoted'
  end

  test 'games played increments for both players' do
    match = build_match(1)
    assert_difference -> { @player1.reload.no_of_games_played }, 1 do
      assert_difference -> { @player2.reload.no_of_games_played }, 1 do
        RankService.new(match).apply
      end
    end
  end
end
