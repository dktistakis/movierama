class MoviesController < ApplicationController
  include MovieHelper

  before_filter :authenticate, only: [:new, :create]
  before_filter :set_movie, only: [:edit, :update, :destroy]
  before_filter :not_found_unless_own_movie, only: [:edit, :update, :destroy]
  
  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(params[:movie])
    @movie.user_id = current_user.id
    if @movie.save
      flash[:success] = 'Movie created successfully'
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
    render 'new'
  end

  def update
    if @movie.update_attributes(params[:movie])
      flash[:success] = 'Movie updated'
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def destroy
    @movie.destroy
    flash[:success] = 'Movie Deleted'
    redirect_to user_path(current_user)
  end

  def index
    @movies = order_movies(Movie)
  end

  # -------------- Private -------------------------------------------------
  private

    def set_movie
      @movie = Movie.find(params[:id])
    end

    def not_found_unless_own_movie
      not_found unless (signed_in? && current_user == @movie.user)
    end
end
