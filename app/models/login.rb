class Login < ActiveRecord::Base

  belongs_to :user

  def self.extract_username_and_password(params)
    return params[:username], params[:password] if params.is_a? Hash
  end

  def self.find_with_credentials(params)
    username, password = extract_username_and_password params
    return if username.blank? or password.blank?

    login = find_or_initialize_by_username username, :include => :user
    login if login.has_password? password
  end

  def self.generate_hash(*credentials)
    Digest::MD5.hexdigest credentials * '+'
  end

  def has_password?(password)
    password_hash == self.class.generate_hash(password, password_salt)
  end

  def self.possible?
    '0' != connection.select_value('SELECT count(id) FROM logins')
  end

  # TODO: rename method
  def self.new!(*args, &block)
    raise NotImplementedError unless possible?
    new(*args, &block)
  end

  CHARS = (0..9).to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  CHARS_SIZE = CHARS.size
  def self.generate_password(length = 8)
    Array.new(length) { CHARS[rand(CHARS_SIZE)] }.to_s
  end
  def self.generate_salt
    Digest::MD5.hexdigest(rand.to_s)[0, 10]
  end

  validates_presence_of :username

  attr_accessor :password
  attr_accessor :return_uri
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password

  def inspect
    username
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
