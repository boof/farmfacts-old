class Stylesheet::IEShadow < StylesheetShadow

  def link
    %Q'<!--[if IE]>#{ super }<![endif]-->'
  end

end
