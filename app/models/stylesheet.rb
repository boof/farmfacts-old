class Stylesheet < Attachment
  attach_shadows :assign => :attributes

  def self.fake(path, *disposition)
    path << '.css' if path[-4, 4] != '.css'
    path = Rails.root.join('public', 'stylesheets', path).to_s
    disposition = 'screen, projections' if disposition.blank?

    new do |stylesheet|
      stylesheet.attaching_type = 'Page'
      stylesheet.disposition = disposition

      (class << stylesheet; self; end).module_eval do
        attr_accessor :attachable
      end
      stylesheet.attachable = Paperclip::Attachment.new 'attachable', stylesheet,
        :path => path, :url  => path[/\/public(\/.+)/, 1]
      stylesheet.attachable.assign File.open(path)
    end
  end

end
