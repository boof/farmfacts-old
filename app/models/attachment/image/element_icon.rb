class Attachment::Image::ElementIcon < Attachment::Image

  def to_s
    super
    #%Q'<link rel="stylesheet" href="#{ attachable }" type="text/css" media="#{ disposition }" />'
  end
  
  
  
end  