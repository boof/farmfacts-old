class Admin::SetupController < Admin::Base
  skip_before_filter :assert_user_authorized
  layout false

  def new
    current.title = 'Create Initial User'
    render :new
  end

  def create
    current.user.save ? proceed_with_configuration : send(:new)
  end

  protected
  def setup_possible?
    render :nothing => true, :status => '400 Bad Request' if Login.possible?
  end
  prepend_before_filter :setup_possible?

  def proceed_with_configuration
    Theme.not_installed['default'].save
    session[:user_id] = current.user.id
    redirect_to admin_configure_path
  end

end
