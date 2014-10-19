class HatesController < ApplicationController

  def create
    @l = Hate.create(user_id: current_user.id, movie_id: params[:movie_id])
    @movie = @l.movie
    @movie.hates_count += 1
    @movie.save
    redirect_to :back
  end

  def destroy
    
  end
end