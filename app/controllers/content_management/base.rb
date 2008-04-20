class ContentManagement::Base < ApplicationController
  
  before_filter :authorize
  
  protected
  def logged_in?
    session[:user]
  end
  def authorize
    redirect_to login_path unless logged_in?
  end
  def user
    User.find session[:user] if logged_in?
  end
  
end
