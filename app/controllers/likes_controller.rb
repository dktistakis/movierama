class LikesController < ApplicationController

  def create
    # raise params.inspect
    l = Like.new(user_id: current_user.id, movie_id: params[:movie_id])
    if l.save
      movie = l.movie
      movie.likes_count = movie.likes.count
      has_hated = Hate.find_by_user_id_and_movie_id(l.user_id, movie.id) 
      if has_hated
        has_hated.destroy
        movie.hates_count = movie.hates.count
      end
      movie.save
    end
    Rails.logger.debug  ">>>>>errors: #{l.errors.inspect}"
    redirect_to :back
  end

  def destroy
    
  end
end
