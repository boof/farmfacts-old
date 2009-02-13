class Admin::SetupController < Admin::Base
  skip_before_filter :assert_user_authorized, :assign_navigation
  layout false

  def new
    page.title = 'Setup: Create Initial User'
    render :new
  end

  def create
    @user.save ? proceed_with_configuration : send(:new)
  end

  protected
  def setup_possible?
    render :nothing => true, :status => '400 Bad Request' if Login.possible?
  end
  prepend_before_filter :setup_possible?

  def proceed_with_configuration
    session[:user_id] = @user.id
    redirect_to admin_configure_path(:setup => true)
  end

  def assign_user
    @user = User.new
    @user.attributes = params[:user]
  end
  before_filter :assign_user

end
