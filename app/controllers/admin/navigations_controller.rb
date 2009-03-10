class Admin::NavigationsController < Admin::Base

  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]

  def index
    @navigations = Navigation.root.all
  end

  def show
    @navigation = Navigation.find params[:ids].last, :include => :navigations
  end

  def new
  end
  def create
    save_or_render(:new, :navigation) { |navigation|
      parent = navigation.parent and parent.add_child navigation
      return_or_redirect_to admin_browse_navigation_path(:ids => navigation.coords)
    }
  end

  def edit
  end
  def update
    save_or_render :edit, :navigation,
      admin_browse_navigation_path(:ids => @navigation.coords)
  end
  def destroy
    navigation = Navigation.find params[:id]
    return_path = unless navigation.root?
      admin_browse_navigation_path(:ids => navigation.parent.coords)
    else
      admin_navigations_path
    end

    Navigation.transaction { navigation.destroy }
    redirect_to return_path
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
