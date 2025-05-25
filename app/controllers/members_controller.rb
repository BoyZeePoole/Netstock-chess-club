class MembersController < ApplicationController
  
  def index
    @members = Member.all
  end

  def show
     @member = Member.find(params[:id])
  end

  def new 
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.current_rank = last_rank
    if @member.save
      redirect_to @member
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def member_params
    params.expect(member: [ :name, :surname, :email_address, :birthday ])
  end

  def last_rank
    last = Member.maximum(:current_rank)
    return 1 if last == nil
    last + 1
  end
end
