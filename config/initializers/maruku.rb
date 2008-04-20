require 'maruku' # add this to the top of your helper

module ActionView::Helpers::TextHelper
  
  def markdown(text)
      text.blank? ? '' : Maruku.new(text).to_html
  end
  
end