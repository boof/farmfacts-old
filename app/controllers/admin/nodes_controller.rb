class Admin::NodesController < Admin::Base

  cache_sweeper :navigation_sweeper, :except => [:new, :edit, :bulk]

  PAGE_TITLES = {
    :new    => 'New Navigation Node',
    :edit   => 'Edit Navigation Node #%s'
  }
  FILE = File.join Rails.root, %w[ app views shared navigation.html.haml ]

  def new
    title_page :new
  end
  def create
    save_or_send(:new, :node) { |node| redirect_to params[:return_to] }
  end

  def edit
    title_page :edit, @node.position
  end
  def update
    save_or_send :edit, :node, admin_navigation_path(@node.container_id)
  end

  def move_down
    @node.move_lower
    redirect_to params[:return_to]
  end
  def move_up
    @node.move_higher
    redirect_to params[:return_to]
  end

  def bulk
    Navigation::Node.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], Navigation::Node,
      params[:node_ids], params

    redirect_to params[:return_to]
  end

  protected
  def assign_new_node
    navigation = Navigation::Container.find params[:navigation_id]
    @node = navigation.nodes.new
  end
  before_filter :assign_new_node, :only => [:new, :create]
  def assign_node_by_id
    @node = Navigation::Node.find params[:id]
  end
  before_filter :assign_node_by_id, :except => [:new, :create, :bulk]

end
