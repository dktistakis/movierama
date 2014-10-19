class UsersController < ApplicationController
  
  before_filter :require_not_logged_in, only: [:new, :create]

  def new
    @title = 'Create new user'
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'User created successfully'
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @title = 'User'
    @user = User.find(params[:id])
    @movies = @user.movies
  end
end
