class ProjectsController < ApplicationController

  def index
    @projects = Project.find :all, :order => :name, :include => [:page, {:roles => :user}]

    title_page 'Projects'
    last_modified @projects.first
  end
  caches_page :index

end
