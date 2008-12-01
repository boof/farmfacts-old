class User < ActiveRecord::Base

  extend Bulk::Destroy

  can_move_things

  has_many :articles, :order => :title, :foreign_key => :author_id
  has_one :login, :dependent => :destroy

  validates_presence_of :name, :email

  def authorized?
    not new_record?
  end

  def to_s
    name
  end

  def self.authorized_by(params)
    login = Login.find_with_credentials params

    if login
      block_given?? yield(login.user) : login.user
    end
  end

  def save_with_login(argument = nil)
    if argument then save_without_login argument
    else
      transaction do
        save_without_login and login.save or raise ActiveRecord::Rollback
      end
    end
  end
  alias_method_chain :save, :login

  protected
  def login_attributes=(attributes)
    build_login unless login
    login.attributes, login.user = attributes, self
  end

end
