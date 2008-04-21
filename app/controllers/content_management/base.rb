class ContentManagement::Base < ApplicationController
  
  before_filter :authorize
  helper_method :user
  
  protected
  def logged_in?
    User.exists? session[:user]
  end
  def authorize
    unless logged_in?
      session[:return_uri] = request.request_uri
      redirect_to login_path
    end
  end
  def user
    User.find session[:user]
  end
  
end
