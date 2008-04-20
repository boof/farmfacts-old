class UsersController < ApplicationController
  
  def login
    @login = Login.new
  end
  
  def authenticate
    reset_session
    
    @login = Login.new params[:login]
    
    if @login.exists?
      session[:user] = @login.user_id
      redirect_to content_management_pages_path
    else
      render :action => :login
    end
  end
  
  def logout
    reset_session
    redirect_to root_path
  end
  
end
