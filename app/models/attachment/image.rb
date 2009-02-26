class Attachment::Image < Attachment

  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper

  def to_s(options = {})
    image_tag attachable.to_s, {:alt => disposition.humanize}.update(options)
  end

end
