module Page::Finder

  def self.extended(base)
    base.named_scope :with_paths,
      proc { |*paths| { :conditions => ['pages.path IN (?)', paths] } }
  end

  def open(path, locales)
    # if language ends with language code try this
    # else try locales in order
    # de-de,de;q=0.8,en-us;q=0.5,en;q=0.3
    # else try without locale
    accepted.with_paths(path).first or raise ActiveRecord::RecordNotFound
  end

  def not_found
    open '/404'
  end

  def path_by_id(id)
    select_first :path, :conditions => { :id => id }
  end

end
