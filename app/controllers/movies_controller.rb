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
    if params[:order] == 'likes'
      @movies = Movie.select('movies.*').joins('left outer join likes on movies.id = likes.movie_id')
                     .select('likes.movie_id, count(likes.*) as cnt').group('movies.id, likes.movie_id')
                     .order('cnt desc')
    elsif params[:order] == 'hates'
      @movies = Movie.select('movies.*').joins('left outer join hates on movies.id = hates.movie_id')
                     .select('hates.movie_id, count(hates.*) as cnt').group('movies.id, hates.movie_id')
                     .order('cnt desc')
    else
      @movies = Movie.order('created_at DESC')
    end
  end
end
