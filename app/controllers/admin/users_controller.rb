class Admin::UsersController < Admin::Base

  cache_sweeper :user_sweeper, :only => [:update, :bulk]

  PAGE_TITLES = {
    :index  => 'Users',
    :show   => 'User “%s”',
    :new    => 'New User',
    :edit   => 'Edit User “%s”'
  }

  def index
    title_page :index
    @users = User.all :order => :name
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
    save_or_render :new, :user, admin_users_path
  end

  def update
    save_or_render :edit, :user,
        params[:return_to].blank?? admin_users_path : params[:return_to]
  end

  def bulk
    User.bulk_methods.include? params[:bulk_action] and
    User.send params[:bulk_action], params[:user_ids]

    redirect_to :action => :index
  end

  protected
  def assign_new_user
    @user = User.new
  end
  before_filter :assign_new_user, :only => [:new, :create]
  def assign_user_by_id
    @user = User.find params[:id]
  end
  before_filter :assign_user_by_id, :only => [:show, :edit, :update]

end
