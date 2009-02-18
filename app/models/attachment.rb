class Attachment < ActiveRecord::Base

  extend Bulk::Destroy

  acts_as_list :scope => 'attaching_type = #{ quote_value attaching_type } AND attaching_id = #{ attaching_id }'
  default_scope :order => 'position'

  belongs_to :attaching, :polymorphic => true
  validates_presence_of :attaching_type, :attaching_id

  Paperclip::Attachment.interpolations[:attaching] = proc do |a, _|
    i = a.instance; "#{ i.attaching_type.tableize }/#{ i.public_id }"
  end
  has_attached_file :attachable,
    :path => ':rails_root/public/var/attachments/:rails_env/:attaching/:basename.:extension',
    :url  => '/var/attachments/:rails_env/:attaching/:basename.:extension'
  validates_attachment_presence :attachable

  protected
  def generate_hash
    self.public_id = Digest::MD5.hexdigest "#{ Time.now }-#{ attaching_id }"
  end
  before_create :generate_hash

end
