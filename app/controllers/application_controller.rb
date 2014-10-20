class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  def authenticate
    # If user is not athenticated then he is re-directed to login page
    unless self.signed_in?
      flash[:notice] = 'You have to be logged in to do that.'
      redirect_to signin_path
    end
  end

  def require_not_logged_in
    redirect_to(root_path) if self.signed_in?
  end

  def not_found
    raise ActionController::RoutingError.new("Not Found: #{params[:path]}")
    # 404 Not Found
  end

  def order_movies_shown
    if params[:order] == 'likes'
      @movies = Movie.select('movies.*').joins('left outer join likes on movies.id = likes.movie_id')
                     .select('likes.movie_id, count(likes.*) as cnt').group('movies.id, likes.movie_id')
                     .order('cnt desc')
    elsif params[:order] == 'hates'
      @movies = Movie.select('movies.*').joins('left outer join hates on movies.id = hates.movie_id')
                     .select('hates.movie_id, count(hates.*) as cnt').group('movies.id, hates.movie_id')
                     .order('cnt desc')
    else
      @movies = Movie.order('created_at DESC')
    end
  end
end
