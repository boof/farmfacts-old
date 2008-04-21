class ContentManagement::Base < ApplicationController
  
  before_filter :authorize
  
  protected
  def logged_in?
    session[:user]
  end
  def authorize
    if user
      logger.info "Authorized #{ user }"
    else
      redirect_to login_path
    end
  end
  def user
    User.find session[:user] if logged_in?
  end
  
end
