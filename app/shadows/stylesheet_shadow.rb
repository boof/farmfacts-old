class StylesheetShadow < Shadows::Base
  
  def link
    %Q'<link rel="stylesheet" href="#{ @origin.attachable }" type="text/css" media="#{ @origin.disposition }" />'
  end
  
end