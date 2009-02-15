module Page::Finder

  def self.extended(base)
    base.named_scope :with_path,
      proc { |path| { :conditions => { :computed_path => path } } }
  end

  def open(path)
    accepted.with_path("#{ path }.#{ I18n.locale }").first or
    raise ActiveRecord::RecordNotFound
  end

  def not_found
    open '/404'
  end

  def path_by_id(id)
    select_first :path, :conditions => { :id => id }
  end

end
