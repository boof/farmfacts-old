module Page::Finder

  def self.extended(base)
    base.named_scope :with_path,
      proc { |path| { :conditions => { :compiled_path => path } } }
  end

  def open(path)
    with_path("#{ path }.#{ I18n.locale }").accepted.first or
    raise ActiveRecord::RecordNotFound
  end

  def not_found
    open '/404'
  end

  def path_by_id(id)
    select_first :path, :conditions => { :id => id }
  end

end
