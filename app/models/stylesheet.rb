class Stylesheet < Attachment

  def self.fake(path, *disposition)
    path << '.css' if path[-4, 4] != '.css'
    path = Rails.root.join('public', 'stylesheets', path).to_s

    new do |stylesheet|
      stylesheet.attaching_type = 'Page'
      stylesheet.disposition = disposition

      (class << stylesheet; self; end).module_eval do
        attr_accessor :attachable
      end
      stylesheet.attachable = Paperclip::Attachment.new 'attachable', stylesheet,
        :path => path, :url => path[/\/public(\/.+)/, 1]
      File.open(path) { |file| stylesheet.attachable.assign file }
    end
  end

  def to_s
    %Q'<link rel="stylesheet" href="#{ attachable }" type="text/css" media="#{ disposition }" />'
  end

  def disposition
    self[:disposition].blank?? 'screen, projection' : self[:disposition]
  end

end
