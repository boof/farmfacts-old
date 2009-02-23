class Attachment::Stylesheet < Attachment

  def to_s
    %Q'<link rel="stylesheet" href="#{ attachable }" type="text/css" media="#{ disposition }" />'
  end

  def disposition
    self[:disposition].blank?? 'screen, projection' : self[:disposition]
  end

end
