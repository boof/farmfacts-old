class UsersController < ApplicationController

  self.allow_forgery_protection = true

  def login
    @login = Login.new
  end

  def auth
    return_uri = session[:return_uri]
    reset_session

    @login = Login.new params[:login]

    if @login.exists?
      session[:user] = @login.user_id
      redirect_to return_uri || admin_pages_path
    else
      session[:return_uri] = return_uri
      render :action => :login
    end
  end

  def logout
    reset_session
    redirect_to root_path
  end

end
