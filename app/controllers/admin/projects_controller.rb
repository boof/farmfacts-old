class Admin::ProjectsController < Admin::Base

  cache_sweeper :project_sweeper, :only => [:create, :update, :bulk]
  cache_sweeper :categorization_sweeper, :only => [:create, :update, :bulk]

  PAGE_TITLES = {
    :index  => 'Projects',
    :show   => 'Project “%s”',
    :new    => 'New Project',
    :edit   => 'Edit Project “%s”'
  }

  def index
    title_page :index
    @projects = Project.find :all, :order => :name, :include => :roles
  end

  def show
    title_page :show, @project
  end

  def new
    title_page :new
    render :action => :new
  end

  def edit
    title_page :edit, @project
    render :action => :edit
  end

  def create
    save_or_send(:new, :project) { |project| redirect_to admin_project_path(project) }
  end

  def update
    save_or_send :edit, :project, admin_project_path(@project)
  end

  def bulk
    Page.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], Page, params[:page_ids]

    redirect_to :action => :index
  end

  protected
  def assign_new_project
    @project = Project.new
  end
  before_filter :assign_new_project, :only => [:new, :create]

  def assign_project_by_id
    @project = Project.find params[:id]
  end
  before_filter :assign_project_by_id, :only => [:show, :edit, :update]

end
