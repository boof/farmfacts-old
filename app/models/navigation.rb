class Navigation < ActiveRecord::Base

  named_scope :root, :conditions => { :parent_id => nil }

  acts_as_nested_set
  uses_registered_path :scope => :locale
  attach_shadows
  has_many :navigations, :foreign_key => :parent_id
  belongs_to :parent, :class_name => "Navigation"

  validates_presence_of :locale, :path, :label

  # Returns a set of itself and all of its nested children
  def full_set
    self.class.base_class.all :conditions => "#{ scope_condition } AND (#{ left_col_name } BETWEEN #{ self[left_col_name] } and #{ self[right_col_name] })", :order => left_col_name
  end

  # Return root node for locale.
  def self.find_by_locale(locale)
    find :first, :conditions => {:parent_id => nil, :locale => locale}
  end

  def self.route_by_path(locale, path)
    set, route = find_by_locale(locale).full_set, []

    # searches tree for given path in nodes
    last_node = set.find { |node| node.path == path }
    route << last_node

    while parent_id = last_node.parent_id
      last_node = set.find { |node| node.id == parent_id }
      route << last_node
    end

    route
  end

  def self.route_by_coords(coords)
    set, route = find_by_id(coords.first).full_set, []

    while last_node = set.find { |node| node.id == coords.last }
      coords.pop
      route << last_node
    end

    route
  end

  def route
    self.class.route_by_coords coords
  end

  def coords
    if parent_id? then parent.coords + [id] else [id] end
  end

  def complete_path_and_label
    if registered_path_id
      self.path = registered_path.path
      self.label = registered_path.label if self.label.blank?
    end
  end
  before_validation :complete_path_and_label
  def complete_locale
    self.locale = if parent_id
      parent.locale
    elsif registered_path
      registered_path.scope
    end
  end
  before_validation :complete_locale

  # after_save
  # rewrite navigated pages when node is visible (global change)
  # rewrite navigated page when node is invisible (local change)

end
