class HatesController < ApplicationController

  before_filter :authenticate
  
  def create
    h = Hate.create(user_id: current_user.id, movie_id: params[:movie_id])
    if h.save
      has_liked = Like.find_by_user_id_and_movie_id(h.user_id, h.movie.id)
      if has_liked
        has_liked.destroy
      end
    end
    redirect_to :back
  end

  def destroy
    h = Hate.find(params[:id])
    h.destroy
    redirect_to :back
  end
end