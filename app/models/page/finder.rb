module Page::Finder

  def self.extended(base)
    base.named_scope :named, proc { |n| {:conditions => ['pages.name = ?', n]} }
    base.named_scope :with_paths, proc { |*paths| { :conditions => ['pages.path IN (?)', paths] } }
  end

  # TODO: negotiate this
  def not_found
    accepted.named('404').first or raise ActiveRecord::RecordNotFound
  end

  def path_by_id(id)
    select_first :path, :conditions => { :id => id }
  end

end
