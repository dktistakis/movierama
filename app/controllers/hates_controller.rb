class HatesController < ApplicationController

  def create
    h = Hate.create(user_id: current_user.id, movie_id: params[:movie_id])
    if h.save
      movie = h.movie
      movie.hates_count = movie.hates.count
      has_liked = Like.find_by_user_id_and_movie_id(h.user_id, movie.id)
      if has_liked
        has_liked.destroy
        movie.likes_count = movie.likes.count
      end
      movie.save
    end
    redirect_to :back
  end

  def destroy
    
  end
end