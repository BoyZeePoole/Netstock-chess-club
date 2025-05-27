class Match < ApplicationRecord
  belongs_to :player_one, class_name: 'Member'
  belongs_to :player_two, class_name: 'Member'

  # enum result: { draw: 0, player_one_wins: 1, player_two_wins: 2 }

  after_create :update_rankings

  private

  def update_rankings
    RankService.new(self).apply
  end
end
