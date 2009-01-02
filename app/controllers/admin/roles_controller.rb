class Admin::RolesController < Admin::Base

  PAGE_TITLES = {
    :new      => 'New Role',
    :edit     => 'Edit Role “%s”'
  }

  def new
    @selectable_users = User.except(*@role.colleague_ids).find :all,
        :select => 'users.id, users.name'

    title_page :new
    render :action => :new
  end

  def edit
    @selectable_users = User.except(*@role.colleague_ids).find :all,
        :select => 'users.id, users.name'

    title_page :edit, @polymorphism.proxy_target
    render :action => :edit
  end

  def create
    save_or_send :new, :role, params[:return_to]
  end

  def update
    save_or_send :edit, :role, params[:return_to]
  end

  def bulk
    Role.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], Role,
      params[:role_ids], params

    redirect_to params[:return_to] || @polymorphism.path.index
  end

  protected
  class RolePolymorphism < Polymorphism; set_namespace :admin end
  def assign_polymorphism
    @polymorphism = RolePolymorphism.new self
  end
  before_filter :assign_polymorphism
  def assign_new_role
    @role = @polymorphism.proxy.new :user_id => current_user.id
  end
  before_filter :assign_new_role, :only => [:new, :create]
  def assign_role_by_id
    @role = @polymorphism.proxy_target
  end
  before_filter :assign_role_by_id, :only => [:edit, :update]

end
