class Navigation < ActiveRecord::Base

  named_scope :roots, :conditions => { :parent_id => nil }
  named_scope :l10n, proc { |locale| {:conditions => { :locale => locale.to_s }} }

  validates_presence_of :locale
  # restrict to root per locale
  validates_uniqueness_of :locale, :scope => :parent_id, :unless => proc { |r| r.parent_id }
  # restrict url to be unique per locale
  validates_uniqueness_of :path, :allow_blank => true, :scope => :locale

  serialize :appendix, Hash

  acts_as_nested_set :scope => 'locale = #{ quote_value locale }'
  uses_registered_path :scope => :locale
  attach_shadows
  belongs_to :parent, :class_name => 'Navigation'

  validates_presence_of :label

  def self.route_by_path(locale, path)
    navigation = l10n(locale).find_by_path path
    navigation ? navigation.route : []
  end

  # Query that selects all parent ids for locale and path.
  # Note: Sqlite, postgres and mysql approved!
  SELECT_COORDS_BY_PATH = 'SELECT parent.id
  FROM navigations AS node, navigations AS parent
  WHERE node.lft BETWEEN parent.lft AND parent.rgt
  AND node.id = %i
  ORDER BY parent.lft'.freeze
  def coords
    if parent_id
      statement = SELECT_COORDS_BY_PATH % id
      connection.select_all(statement).map! { |attrs| attrs['id'].to_i }
    else
      [ id ]
    end
  end

  def route
    self.class.find coords, :order => 'navigations.lft'
  end
  def route_to_path(child_path)
    self.class.route_by_path locale, child_path
  end

  def complete_path_and_label
    if registered_path_id
      self.path = registered_path.path
      self.label = registered_path.label if label.blank?
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
    self.class.l10n(locale).scoped :order => 'navigations.lft'
  end

  def children
    tree_scope.scoped :conditions => {:parent_id => id}
  end
  def child(path)
    children.find_by_path path
  end

  def calculated_path
    @calculated_path ||= if !path.blank? then path
    elsif first_child = children.first then first_child.calculated_path
    else ''
    end
  end

  protected
  def pagify_pagified_pages
    Page.with_paths(*@paths).all.each { |p| p.pagify if p.pagified? }
  end
  def store_paths
    @paths = tree_scope.select_all :path
  end
  after_save :store_paths, :pagify_pagified_pages
  before_destroy.unshift Callback.new(:before_destroy, :store_paths)
  after_destroy :pagify_pagified_pages

end
