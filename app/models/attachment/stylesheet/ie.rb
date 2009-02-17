class Attachment::Stylesheet::IE < Attachment::Stylesheet

  def to_s
    %Q'<!--[if IE]>#{ super }<![endif]-->'
  end

end