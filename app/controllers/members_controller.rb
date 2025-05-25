class MembersController < ApplicationController
  
  before_action :find_member, only: %i[ show edit update ]

  def index
    @members = Member.all
  end

  def show
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

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to @member
    else
      render :edit, status: :unprocessable_entity
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

  def find_member
    @member = Member.find(params[:id])
  end
end
