class Navigation < ActiveRecord::Base

  named_scope :root, :conditions => { :parent_id => nil }
  named_scope :local_root, proc { |locale|
    {:conditions => { :parent_id => nil, :locale => locale }}
  }
  validates_uniqueness_of :locale, :scope => :parent_id, :unless => proc { |r| r.parent_id }

  acts_as_nested_set :scope => 'locale = #{ quote_value locale }'
  default_scope :order => 'navigations.lft'
  uses_registered_path :scope => :locale
  attach_shadows
  has_many :navigations, :foreign_key => :parent_id
  belongs_to :parent, :class_name => "Navigation"

  validates_presence_of :path, :label

  # Returns a set of itself and all of its nested children
  def full_set
    self.class.base_class.all :conditions => "#{ scope_condition } AND (#{ left_col_name } BETWEEN #{ self[left_col_name] } and #{ self[right_col_name] })", :order => left_col_name
  end

  # Return root node for locale.
  def self.find_by_locale(locale)
    find :first, :conditions => {:parent_id => nil, :locale => locale}
  end

  def self.route_by_path(locale, path)
=begin
Retrieving a Single Path

With the nested set model, we can retrieve a single path without having multiple self-joins:

SELECT parent.name
FROM nested_category AS node,
nested_category AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.name = 'FLASH'
ORDER BY parent.lft;
=end
    set, route = find_by_locale(locale).tree_scope.all, []

    # searches tree for given path in nodes
    last_node = set.find { |node| node.path == path }
    return [] unless last_node
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

  attr_accessor :children

  def self.rebuild_tree_without(*ids)
    locale = select_first :locale, :conditions => { :id => ids.first }
    root, lost = local_root(locale).first, []
    # removes node from tree
    children = root.all_children.reject { |navigation| navigation.id == ids.first }
    children.inject(root) { |parent, navigation|
      if navigation.parent_id == parent.id
        parent.children << navigation
        navigation
      elsif parent.root?
        lost << navigation
        parent
      elsif child = children.find { |child| child.id == navigation.parent_id }
        child.children << navigation
        child
      else
        lost << navigation
        parent
      end
    }
  end

  def route_by_path(path)
    self.class.route_by_path locale, path
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
    end if locale.blank?
  end
  before_validation :complete_locale

  def tree_scope
    self.class.base_class.scoped :conditions => scope_condition
  end
  # TODO: Methode sollte einen "vernünftigen" Namen bekommen, irgendwas mit putschi puchi...
  def putschi_putschi_pages # war mal ... mein gehirn, weiss noch nicht was besser is...
    # Ok, Dani dreht durch...
    Page.with_paths(*@paths).all.each { |p| p.pagify if p.pagified? }
  end
  alias_method :pagify_pagified_pages, :putschi_putschi_pages
  def store_paths
    root = self.class.root.find_by_locale locale
    @paths = root.tree_scope.select_all :path
  end
  after_save :store_paths, :pagify_pagified_pages
  before_destroy.unshift Callback.new(:before_destroy, :store_paths)
  after_destroy :pagify_pagified_pages

end
