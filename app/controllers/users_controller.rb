class UsersController < ApplicationController

  def auth
    reset_session

    User.authorized_by params[:login] do |user|
      session[:user_id] = user.id
    end

    redirect_to params[:return_uri] || admin_pages_path
  end

  def logout
    reset_session
    redirect_to root_path
  end

end
