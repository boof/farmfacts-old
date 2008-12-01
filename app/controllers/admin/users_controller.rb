class Admin::UsersController < Admin::Base

  PAGE_TITLES = {
    :index  => 'Users',
    :new    => 'New User',
    :edit   => 'Edit "%s"'
  }

  before_filter :assign_user, :except => [:index, :bulk]

  def index
    title_page :index
    @users = User.all :order => :name
  end

  def bulk
    User.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], User, params[:user_ids]

    redirect_to :action => :index
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
    save_or_send :new, :user
  end

  def update
    save_or_send :edit, :user
  end

  protected
  def assign_user
    @user = ( User.find params[:id] rescue User.new )
  end

end
