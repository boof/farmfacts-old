class Admin::NavigationsController < Admin::Base

  cache_sweeper :page_sweeper, :except => [:create, :update, :destroy]

  def index
    @navigations = Navigation.root.all
  end

  def show
    @navigation = Navigation.find params[:ids].last, :include => :navigations
  end

  def new
  end
  def create
    ActiveRecord::Base.transaction do
      save_or_render(:new, :navigation) { |navigation|
        parent = navigation.parent and parent.add_child navigation
        return_or_redirect_to admin_navigation_path(:ids => navigation.coords)
      }
    end
  end

  def edit
  end
  def update
    ActiveRecord::Base.transaction do
      save_or_render :edit, :navigation,
        admin_navigation_path(:ids => @navigation.coords)
    end
  end

  protected
  def assign_new_navigation
    @navigation = Navigation.new :parent => Navigation.find_by_id(params[:parent_id])
  end
  before_filter :assign_new_navigation, :only => [:new, :create]
  def assign_navigation_by_id
    @navigation = Navigation.find params[:id]
  end
  before_filter :assign_navigation_by_id, :only => [:edit, :update]

end
