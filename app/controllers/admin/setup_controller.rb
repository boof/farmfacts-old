class Admin::SetupController < Admin::Base
  skip_before_filter :assert_user_authorized, :assign_navigation
  layout false

  PAGE_TITLES = { :new  => 'Setup' }

  def new
    title_page :new
    render :action => :new
  end

  def create
    save_or_send :new, :user do |@user|
      session[:user_id] = @user.id
      redirect_to edit_admin_user_path(@user)
    end
  end

  protected
  def setup_possible?
    render :nothing => true, :status => '400 Bad Request' if Login.possible?
  end
  before_filter :setup_possible?

  def assign_user
    @user = User.new
  end
  before_filter :assign_user

end
