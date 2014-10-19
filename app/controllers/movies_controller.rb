class MoviesController < ApplicationController
  
  before_filter :authenticate, except: [:index]

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
    if params[:order] == 'likes'
      @movies = Movie.order('likes_count DESC')
    elsif params[:order] == 'hates'
      @movies = Movie.order('hates_count DESC')  
    else
      @movies = Movie.order('created_at DESC')
    end
  end
end
