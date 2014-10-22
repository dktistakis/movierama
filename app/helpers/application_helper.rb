module ApplicationHelper

  def own_movie?(movie)
    current_user.id == movie.user_id
  end

  def liked_movie?(movie)
    current_user.votes.likes.where(movie_id: movie.id).first
  end

  def hated_movie?(movie)
    current_user.votes.hates.where(movie_id: movie.id).first
  end
end
