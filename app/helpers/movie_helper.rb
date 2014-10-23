module MovieHelper

  def own_movie?(movie)
    current_user.id == movie.user_id
  end

  def liked_movie?(movie)
    current_user.votes.likes.where(movie_id: movie.id).first if current_user
  end

  def hated_movie?(movie)
    current_user.votes.hates.where(movie_id: movie.id).first if current_user
  end
  
  def order_movies(movies)
    if params[:order] == 'likes'
      ordering = 'likes_count DESC'
    elsif params[:order] == 'hates'
      ordering = 'hates_count DESC'
    else
      ordering = 'created_at DESC'
    end
    movies.order(ordering).paginate(per_page: 10, page: params[:page])
  end

  def kind_of_vote(movie)
    vote = current_user.votes.where(movie_id: movie.id).first
    if vote && vote.positive
      'like'
    else
      'hate'
    end
  end
end