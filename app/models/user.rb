class User < ActiveRecord::Base

  notebook_path = File.join Rails.root, %w[log notes.log]
  Notebook = ActiveSupport::BufferedLogger.new notebook_path

  has_many :publications, :order => :created_at, :foreign_key => :editor_id
  has_many :articles, :order => :title, :foreign_key => :author_id
  has_one :login, :dependent => :destroy

  def publish(type, id)
    will :save, publication_for(type, id)
  end

  validates_associated :login
  validates_presence_of :name, :email

  def authorized?
    not new_record?
  end

  def to_s
    self[:name]
  end

  def will(action, object, *args)
    before  = object.inspect
    result  = object.send(action, *args)
    after   = object.inspect

    Notebook.info msg = (before == after) ?
      "#{ name } #{ action }s\n  #{ before }.\n" :
      "#{ name } #{ action }s\n  #{ before }\n  #{ after }.\n"

    if block_given?
      yield result
    else
      result
    end
  end

  protected
  def publication_for(type, id)
    publications.build :publishable_type => type, :publishable_id => id
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
