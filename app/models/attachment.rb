class Attachment < ActiveRecord::Base

  extend Bulk::Destroy

  belongs_to :attaching, :polymorphic => true
  validates_presence_of :attaching_type, :attaching_id

  Paperclip::Attachment.interpolations[:attaching] = proc do |a, _|
    i = a.instance; "#{ i.attaching_type.tableize }/#{ i.attaching_id }"
  end
  has_attached_file :attachable,
    :path => ':rails_root/public/var/attachments/:rails_env/:attaching/:basename.:extension',
    :url  => '/var/attachments/:rails_env/:attaching/:basename.:extension'
  validates_attachment_presence :attachable

end
