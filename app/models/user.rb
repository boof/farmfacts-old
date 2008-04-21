class User < ActiveRecord::Base
  
  has_many :publications, :order => :created_at
  has_many :articles, :order => :title
  has_one :login, :dependent => :destroy
  
  def publish(type, id)
    will :provoke, publication_for(type, id), self
  end
  def revoke(type, id)
    will :revoke, publication_for(type, id), self
  end
  
  validates_associated :login
  validates_presence_of :name, :email
  
  def to_s
    self[:name]
  end
  
  def will(action, object, *args)
    logger.info "#{ name } #{ action }s #{ object.class.name } '#{ object }'"
    
    if block_given?
      yield object.send(action, *args)
    else
      object.send(action, *args)
    end
  end
  
  protected
  def publication_for(type, id)
    attributes = {:publishable_type => type, :publishable_id => id}
    
    Publication.find :first, :conditions => attributes or
    Publication.new attributes
  end
  def login_attributes=(attributes)
    @login_attrs = attributes
  end
  
  def save_with_login
    success = false
    
    ActiveRecord::Base.transaction do
      success = save_without_login
      success &&= begin
        @login_attrs.nil? or
        (login or build_login).update_attributes @login_attrs
      end
      
      rollback_db_transaction unless success
    end
    
    success
  end
  alias_method_chain :save, :login
  
end
