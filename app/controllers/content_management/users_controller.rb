class ContentManagement::UsersController < ContentManagement::Base
  
  def index
    @users = User.find :all
    @page_title = 'Content Management - Users'
  end
  
  def new
    @user ||= User.new
    render :action => :new
  end
  
  def edit
    @user ||= User.find params[:id]
    render :action => :edit
  end
  
  def create
    @user = User.new params[:user]
    
    user.will :save, @user do |saved|
      if saved
        redirect_to :action => :index
      else
        send :new
      end
    end
  end
  
  def update
    @user = User.find params[:id]
    @user.attributes = params[:user]
    
    user.will :save, @user do |saved|
      if saved
        redirect_to :action => :index
      else
        send :edit
      end
    end
  end
  
  def destroy
    user.will :destroy, User.find( params[:id] )
    redirect_to :action => :index
  end
  
end
