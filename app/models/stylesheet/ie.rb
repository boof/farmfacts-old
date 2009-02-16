class Stylesheet::IE < Stylesheet
  
  def to_s
    %Q'<!--[if IE]>#{ super }<![endif]-->'
  end

end