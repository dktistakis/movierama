class LikesController < ApplicationController

  def create
    # raise params.inspect
    @l = Like.new(user_id: params[:user_id], movie_id: params[:movie_id])
    if @l.save
      @movie = @l.movie
      @movie.likes_count += 1
      @movie.save
      Rails.logger.debug  ">>>>>movie #{@movie.inspect}"
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def destroy
    
  end
end
