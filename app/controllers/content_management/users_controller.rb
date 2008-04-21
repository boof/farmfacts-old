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
    
    if @user.save
      redirect_to :action => :index
    else
      send :new
    end
  end
  
  def update
    @user = User.find params[:id]
    @user.attributes = params[:user]
    
    if @user.save
      redirect_to :action => :index
    else
      send :edit
    end
  end
  
  def destroy
    User.destroy params[:id]
    redirect_to :action => :index
  end
  
end
