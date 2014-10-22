class VotesController < ApplicationController

  before_filter :authenticate, only: [:create, :destroy]

  def create
    if params[:vote] == 'true'
      v = Vote.new(user_id: current_user.id, movie_id: params[:movie_id], positive: true)
    else
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
