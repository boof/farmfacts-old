class Attachment::Stylesheet::IE < Attachment::Stylesheet
  
  module Extension
    def to_s
      %Q'<!--[if IE]>#{ super }<![endif]-->'
    end
  end
  include Extension

end