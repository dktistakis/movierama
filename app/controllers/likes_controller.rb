class LikesController < ApplicationController

  before_filter :authenticate, only: [:create, :destroy]

  def create
    l = Like.new(user_id: current_user.id, movie_id: params[:movie_id])
    if l.save
      has_hated = Hate.find_by_user_id_and_movie_id(l.user_id, l.movie.id) 
      if has_hated
        has_hated.destroy
      end
    end
    redirect_to :back
  end

  def destroy
    l = Like.find(params[:id])
    l.destroy
    redirect_to :back
  end
end
