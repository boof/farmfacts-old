class Login < ActiveRecord::Base

  belongs_to :user

  def self.generate_hash(*credentials)
    Digest::MD5.hexdigest credentials * '+'
  end

  CHARS = (0..9).to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  CHARS_SIZE = CHARS.size
  def self.generate_password(length = 8)
    Array.new(length) { CHARS[rand(CHARS_SIZE)] }.to_s
  end
  def self.generate_salt
    Digest::MD5.hexdigest(rand.to_s)[0, 10]
  end

  def exists?
    login = self.class.find :first, :conditions => {:username => username}

    if login
      password_hash = self.class.generate_hash password, login.password_salt

      if password_hash.eql? login.password_hash
        clear_password

        self[:user_id] = login.user_id

        true
      end
    end
  end

  validates_presence_of :username

  attr_accessor :password
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password

  def inspect
    self[:username]
  end

  def sync_passwords
    @password_confirmation = @password; nil
  end

  def update_password_credentials
    unless @password.blank?
      pw_salt = self.class.generate_salt
      pw_hash = self.class.generate_hash(@password, pw_salt)

      self.attributes = {
        :password_salt => pw_salt,
        :password_hash => pw_hash
      }
    end
  end
  before_save :update_password_credentials
  protected :update_password_credentials

  def clear_password
    @password = nil
    sync_passwords
  end
  after_save :clear_password
  protected :clear_password

end
