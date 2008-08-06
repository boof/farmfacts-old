class Admin::UsersController < Admin::Base

  PAGE_TITLES = {
    :index  => 'Users',
    :new    => 'New User',
    :edit   => 'Edit "%s"'
  }

  before_filter :assign_new_user,
    :only => [:new, :create]
  before_filter :assign_user_by_id,
    :only => [:edit, :update, :destroy]

  def index
    title_page :index
    @users = User.find :all
  end

  def new
    title_page :new
    render :action => :new
  end

  def edit
    title_page :edit, @user
    render :action => :edit
  end

  def create
    @user.attributes = params[:user]

    current_user.will :save, @user do |saved|
      if saved
        redirect_to :action => :index
      else
        send :new
      end
    end
  end

  def update
    @user.attributes = params[:user]

    current_user.will :save, @user do |saved|
      if saved
        redirect_to :action => :index
      else
        send :edit
      end
    end
  end

  def destroy
    current_user.will :destroy, @user
    redirect_to :action => :index
  end

  protected
  def assign_new_user
    @user = User.new
  end
  def assign_user_by_id
    @user = User.find params[:id]
  end

end
