class Attachment < ActiveRecord::Base

  extend Bulk::Destroy

  acts_as_list :scope => 'attaching_type = #{ quote_value attaching_type } AND attaching_id = #{ attaching_id }'
  default_scope :order => 'position'

  belongs_to :attaching, :polymorphic => true
  validates_presence_of :attaching_type, :attaching_id, :if => proc { |a| a.attaching }

  Paperclip::Attachment.interpolations[:attaching] = proc do |a, _|
    i = a.instance; "#{ i.attaching_type.tableize }/#{ i.public_id }"
  end
  Paperclip::Attachment.interpolations[:type] = proc do |a, _|
    module_names = "#{ a.instance.type }".split '::'

    if module_names.empty?
      module_names << 'Attachment'
    else
      # drop 1st element which should be 'Attachment'
      module_names.shift 
    end

    module_names.map! { |module_name| module_name.tableize }.join '/'
  end
  has_attached_file :attachable,
    :path => ':rails_root/public/var/attachments/:rails_env/:attaching/:type/:basename.:extension',
    :url  => '/var/attachments/:rails_env/:attaching/:type/:basename.:extension'
  validates_attachment_presence :attachable

  protected
  def generate_hash
    self.public_id = Digest::MD5.hexdigest "#{ Time.now }-#{ attaching_id }"
  end
  before_create :generate_hash

end
