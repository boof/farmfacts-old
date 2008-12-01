module Page::Finder

  def open(path)
    accepted.with_path( path ).first or
    raise ActiveRecord::RecordNotFound
  end

  def not_found
    open '/not_found'
  end

  def path_by_id(id)
    find( id, :select => :path ).path rescue nil
  end

end
