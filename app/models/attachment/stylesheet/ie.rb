class Attachment::Stylesheet::IE < Attachment::Stylesheet

  module Extension
    include ::Attachment::Stylesheet::Extension
    def to_s
      %Q'<!--[if IE]>#{ super }<![endif]-->'
    end
  end
  include Extension

end