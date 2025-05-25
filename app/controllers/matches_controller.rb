class MatchesController < ApplicationController
  

  def edit
    @members = Member.all
  end

  def create
    @player1_id = params[:members_p1].to_i
    @player2_id = params[:members_p2].to_i
    @result = params[:result].to_i
    return unless validate
    calculate_rank
    
  end

  def calculate_rank
    if unchanged?
      redirect_to root_path
      return
    end
    

    if @result == 0
      @lower_rank.current_rank -= 1
      @lower_rank.save!
      redirect_to root_path
      return
    end

    if @lower_rank == @winner
      
      @lower_rank.current_rank = @lower_rank.current_rank - (diff(@player1.current_rank, @player2.current_rank).to_f / 2.to_f).ceil()
      @lower_rank.save!
      @highest_rank.current_rank += 1
      @highest_rank.save!
    end
    redirect_to root_path
  end

  private
  
  def save_member?(member)
    if member.save
        return true
      else
        redirect_to edit_matches_path, notice: "An error occurred trying to adjust rank!" 
        return false
      end
  end

  def unchanged?
    if @result == 0  # draw
      return true if adjacent?
    else
      return true if @winner == @highest_rank
    end
    
    false
  end

  def adjacent?
    return diff(@player1.current_rank, @player2.current_rank) == 1
  end

  def diff(a, b)
    (a - b).abs
  end

  def validate
    if @player1_id == @player2_id
      redirect_to edit_matches_path, notice: "Please select differrent players..." 
      return false
    end
   
    @player1 = Member.find(@player1_id)
    @player2 = Member.find(@player2_id)

    @highest_rank = @player1.current_rank < @player2.current_rank ? @player1 : @player2
    @lower_rank = @player1.current_rank > @player2.current_rank ? @player1 : @player2
    
    if @result == 0 
      @winner = nil
      return true
    else
      @winner = @result == @player1.id ? @player1 : @player2
      return true
    end
    
    if @result != @player1_id || @result != @player2_id 
      redirect_to edit_matches_path, notice: "Please select either #{@player1.name} or #{@player2.name}"
      return false
    end
    true
  end
end