module ApplicationHelper

  def own_movie?(movie)
    current_user.id == movie.user_id
  end

  def liked_movie?(movie)
    Like.find_by_movie_id_and_user_id(movie.id, current_user.id)
  end

  def hated_movie?(movie)
    Hate.find_by_movie_id_and_user_id(movie.id, current_user.id)
  end
end
