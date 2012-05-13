class UsersController < ApplicationController
   before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end

  def edit
    
  end

  def update
    
    if @user.update_attributes(params[:user])
      flash[:success] = "success"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] ="Welcome #{@user.name}"
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end
  private
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in"
    end
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
