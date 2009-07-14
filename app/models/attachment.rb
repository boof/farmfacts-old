class Attachment < ActiveRecord::Base

  extend Bulk::Destroy

  acts_as_list :scope => 'attaching_type = #{ quote_value attaching_type } AND attaching_id = #{ attaching_id }'
  default_scope :order => 'position' # TODO: Move this into boof/acts_as_list.git.

  belongs_to :attaching, :polymorphic => true
  validates_presence_of :attaching_type, :attaching_id, :if => proc { |a| a.attaching }

  named_scope :stylesheets, :conditions => ['attachments.type IN (?)', %w[ Attachment::Stylesheet Attachment::Stylesheet::IE ]]
  named_scope :javascripts, :conditions => ['attachments.type IN (?)', %w[ Attachment::Javascript ]]
  named_scope :images, :conditions => ['attachments.type IN (?)', %w[ Attachment::Image ]]
  named_scope :element_icons, :conditions => { :type => 'Attachment::Image::ElementIcon' }

  Paperclip.interpolates :normalized_basename do |a, *|
    filename = a.original_filename.mb_chars.
      normalize(:kd).gsub(/[^\x00-\x7F]/n, '').
      to_s

    filename.gsub(/#{ File.extname filename }$/, '')
  end
  Paperclip.interpolates :attaching do |a, *|
    i = a.instance; "#{ i.attaching_type.tableize }/#{ i.public_id }"
  end
  Paperclip.interpolates :type do |a, *|
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
    :path => ':rails_root/public/var/:rails_env/attachments/:attaching/:type/:normalized_basename.:extension',
    :url  => '/var/:rails_env/attachments/:attaching/:type/:normalized_basename.:extension'
  validates_attachment_presence :attachable

  protected
  def set_public_id
    self.public_id = Digest::MD5.hexdigest "#{ attaching_id }"
  end
  before_create :set_public_id

end
