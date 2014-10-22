class VotesController < ApplicationController

  before_filter :authenticate, only: [:create, :destroy]

  def create
    # raise params.inspect
    if params[:vote] == 'true'
      has_hated = current_user.votes.hates.where(movie_id: params[:movie_id]).first
      if has_hated
        has_hated.destroy
      end
      v = Vote.new(user_id: current_user.id, movie_id: params[:movie_id], positive: true)
    else
      has_liked = current_user.votes.likes.where(movie_id: params[:movie_id]).first
      if has_liked
        has_liked.destroy
      end
      v = Vote.new(user_id: current_user.id, movie_id: params[:movie_id], positive: false)
    end
    v.save
    redirect_to :back
  end

  def destroy
    v = Vote.find(params[:id])
    v.destroy
    redirect_to :back
  end
end
