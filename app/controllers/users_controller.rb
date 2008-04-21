class UsersController < ApplicationController
  
  def login
    @login = Login.new
  end
  
  def auth
    return_uri = session[:return_uri]
    reset_session
    
    @login = Login.new params[:login]
    
    if @login.exists?
      session[:user] = @login.user_id
      redirect_to return_uri || content_management_pages_path
    else
      render :action => :login
    end
    session[:return_uri] = return_uri
  end
  
  def logout
    reset_session
    redirect_to root_path
  end
  
end
