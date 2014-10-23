class MoviesController < ApplicationController
  include MovieHelper

  before_filter :authenticate, only: [:new, :create]
  
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

  def index
    @movies = order_movies(Movie)
  end
end
