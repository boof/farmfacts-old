class Page::Path < ActiveRecord::Base

  belongs_to :page

  named_scope :filter_by_name_or_path, proc { |string|
    string = "/#{ string }" if string[0, 1] != '/'
    { :conditions => ['name = ? or path = ?', string, string] }
  }

  def self.find_all_by_request_path(string, limited_locales = [])
    scope = filter_by_name_or_path string
  end

  protected

    def name_reads_from_page
      write_attribute :name, page.name
    end
    before_save :name_reads_from_page

    def locale_reads_from_page
      write_attribute :locale, page.locale
    end
    before_save :locale_reads_from_page

    def name_and_locale_generate_path
      write_attribute :path, "#{ name }.#{ locale }"
    end
    before_save :name_and_locale_generate_path

end
