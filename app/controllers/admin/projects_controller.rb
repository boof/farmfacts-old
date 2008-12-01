class Admin::ProjectsController < Admin::Base

  PAGE_TITLES = {
    :index  => 'Projects',
    :new    => 'New Project',
    :edit   => 'Edit "%s"'
  }

  before_filter :assign_new_project,
    :only => [:new, :create]
  before_filter :assign_project_by_id,
    :only => [:edit, :update, :destroy]

  cache_sweeper :project_sweeper, :only => [:create, :update, :destroy]

  def index
    title_page :index
    @projects = Project.find :all, :order => :name
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
    @project.attributes = params[:project]

    current_user.will :save, @project do |saved|
      if saved
        redirect_to :action => :index
      else
        send :new
      end
    end
  end

  def update
    @project.attributes = params[:project]

    current_user.will :save, @project do |saved|
      if saved
        redirect_to :action => :index
      else
        send :edit
      end
    end
  end

  def destroy
    current_user.will :destroy, @project
    redirect_to :action => :index
  end

  protected
  def assign_new_project
    @project = Project.new
  end
  def assign_project_by_id
    @project = Project.find params[:id]
  end

end
