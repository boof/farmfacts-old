class User < ActiveRecord::Base
  
  has_many :publications, :order => :created_at
  has_many :articles, :order => :title
  has_one :login
  
  def publish(type, id)
    publication_for(type, id).provoke self
  end
  def revoke(type, id)
    publication_for(type, id).revoke self
  end
  
  protected
  def publication_for(type, id)
    attributes = {:publishable_type => type, :publishable_id => id}
    
    Publication.find :first, :conditions => attributes or
    Publication.new attributes
  end
  
end
