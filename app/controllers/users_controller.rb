class UsersController < ApplicationController
  
  before_filter :require_not_logged_in, only: [:new, :create]

  def new
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
    if params[:order] == 'likes'
      @movies = Movie.select('movies.*').joins('left outer join likes on movies.id = likes.movie_id')
                     .select('likes.movie_id, count(likes.*) as cnt').where("movies.user_id = #{@user.id}")
                     .group('movies.id, likes.movie_id').order('cnt desc')
    elsif params[:order] == 'hates'
      @movies = Movie.select('movies.*').joins('left outer join hates on movies.id = hates.movie_id')
                     .select('hates.movie_id, count(hates.*) as cnt').where("movies.user_id = #{@user.id}")
                     .group('movies.id, hates.movie_id').order('cnt desc')
    else
      @movies = @user.movies.order('created_at DESC')
    end
  end
end
