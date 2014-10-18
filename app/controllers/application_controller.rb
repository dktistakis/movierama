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
    deny_access unless signed_in?
  end

  def require_not_logged_in
    redirect_to(root_path) if self.signed_in?
  end
end
