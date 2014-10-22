module MovieHelper

  def own_movie?(movie)
    current_user.id == movie.user_id
  end

  def liked_movie?(movie)
    current_user.votes.likes.where(movie_id: movie.id).first
  end

  def hated_movie?(movie)
    current_user.votes.hates.where(movie_id: movie.id).first
  end
  
  def order_movies(movies)
    if params[:order] == 'likes'
      @movies = movies.order('likes_count DESC')
    elsif params[:order] == 'hates'
      @movies = movies.order('hates_count DESC')
    else
      @movies = movies.order('created_at DESC')
    end
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