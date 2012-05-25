class TournamentsController < ApplicationController
  before_filter :signed_in_user
  
  def new
    @tournament = Tournament.new
  end

  def edit
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def index
  end

  def create
    @tournament = Tournament.new(params[:tournament])
    if @tournament.save
      flash[:success] = "Tournament Created"
      redirect_to @tournament
    else
      render 'new'
    end
  end
end
