class MoviesController < ApplicationController
  
  before_filter :authenticate, except: :index
  
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

  def update
  end

  def edit
  end

  def destroy
  end

  def index
    order_movies(Movie)
  end
end
