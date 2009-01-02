Slug.class_eval do

  named_scope :article_slug, proc { |*names|
    {:conditions => ["#{ with_names names } AND sluggable_type = ?", 'Article']}
  }

  named_scope :sluggable_ids, proc { |type, *names|
    {
      :conditions => ["#{ with_names names } AND sluggable_type = ?", type],
      :select => :sluggable_id
    }
  }

end
