module Categorizable
  class Category < ActiveRecord::Base
    extend Bulk::Destroy

    set_table_name 'categorizable_categories'

    Paperclip::Attachment.interpolations[:param] = proc do |a, _|
      a.instance.to_param
    end
    has_attached_file :icon,
      :default_url  => '',
      :path         => ':rails_root/public/var/icons/:param.:extension',
      :url          => '/var/icons/:param.:extension'
    validates_attachment_content_type :icon, :content_type => %w[image/jpeg image/gif image/png]

    has_friendly_id :slug, :strip_diacritics => true
    registers_path { |category| "/categories/#{ category.to_param }" }

    validates_presence_of :name
    has_many :categorizations, :class_name => 'Categorizable::Categorization',
        :dependent => :delete_all

    def to_s
      name
    end
    def name=(name)
      write_attribute :slug, name.parameterize
      write_attribute :name, name
    end
    def clear_icon=(value)
      icon.instance_eval { queue_existing_for_delete }
    end

    def self.find_all_by_names(*names)
      find :all, :conditions => ['name IN (?)', names]
    end
    def self.ids_for_names(*names)
      select = 'SELECT id FROM categorizable_categories'

      name_column = columns_hash['name']
      names.map! { |name| quote_value name, name_column }

      connection.select_values "#{ select } WHERE name IN (#{ names * ',' })"
    end

  end
end
