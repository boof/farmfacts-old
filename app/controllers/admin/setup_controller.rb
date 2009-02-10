class Admin::SetupController < Admin::Base
  skip_before_filter :assert_user_authorized, :assign_navigation
  layout false

  sequence :setup do
    configure_farmfacts do |s|
      s.next if @properties.valid?
    end
    create_initial_user do |s|
      s.last if @user.valid?
    end
  end

  def new
    walk_setup_sequence :configure_farmfacts
  end

  def create
    walk_setup_sequence

    if setup_sequence.finished_with? @step
      finalize_setup and proceed_with_profile
    else
      render :new
    end
  end

  protected
  def setup_possible?
    render :nothing => true, :status => '400 Bad Request' if Login.possible?
  end
  prepend_before_filter :setup_possible?

  def finalize_setup
    ActiveRecord::Base.transaction do
      @properties.save and @user.save or
      raise ActiveRecord::Rollback
    end
  end
  def proceed_with_profile
    session[:user_id] = @user.id
    redirect_to edit_admin_user_path(@user)
  end

  def assign_preferences
    @preferences = Preferences::FarmFacts.new params[:preferences]
  end
  before_filter :assign_user
  def assign_user
    @user = User.new params[:user]
  end
  before_filter :assign_user

end
