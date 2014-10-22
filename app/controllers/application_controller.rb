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

  def order_movies(movies)
    if params[:order] == 'likes'
      @movies = movies.order('likes_count DESC')
    elsif params[:order] == 'hates'
      @movies = movies.order('hates_count DESC')
    else
      @movies = movies.order('created_at DESC')
    end
  end
end
