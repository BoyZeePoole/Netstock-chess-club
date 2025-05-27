class MatchesController < ApplicationController

  def edit
    @members = Member.all
    @match = Match.new
  end

  def create
    member1 = Member.find(match_params['player_one'].to_i)
    member2 = Member.find(match_params['player_two'].to_i)
    @match = Match.new(
      player_one: member1, 
      player_two: member2, 
      result: match_params['result'].to_i)

    if @match.save
      redirect_to root_path
    else
      redirect_to edit_matches_path, notice: @match.errors.full_messages 
    end
  end

  def match_params
     params.require(:match).permit(:player_one, :player_two, :result)
  end

end