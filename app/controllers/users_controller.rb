class UsersController < ApplicationController
  def new
    @title = 'Create new user'
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'User created successfully'
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @title = 'User'
    @user = User.find(params[:id])
  end
end
