class Admin::NavigationsController < Admin::Base

  cache_sweeper :navigation_sweeper, :only => [:create, :update]
  # main: sweeps actions /categories/\n+

  PAGE_TITLES = {
    :index  => 'Navigations',
    :new    => 'New Navigation',
    :show   => 'Navigation “%s”',
    :edit   => 'Edit Navigation “%s”'
  }
  FILE = File.join Rails.root, %w[ app views shared navigation.html.haml ]

  def index
    @navigations = Navigation::Container.find :all, :order => :element_id
    title_page :index
  end

  def show
    title_page :show, @navigation
  end

  def new
    title_page :new
  end
  def create
    save_or_send(:new, :navigation) { |navigation|
        redirect_to admin_navigation_path(navigation) }
  end

  def edit
    title_page :edit, @navigation
  end
  def update
    save_or_send :edit, :navigation, admin_navigation_path(@navigation)
  end

  protected
  def assign_new_navigation
    @navigation = Navigation::Container.new
  end
  before_filter :assign_new_navigation, :only => [:new, :create]
  def assign_navigation_by_id
    @navigation = Navigation::Container.find params[:id]
  end
  before_filter :assign_navigation_by_id, :only => [:show, :edit, :update]

end
