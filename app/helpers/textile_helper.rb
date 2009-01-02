module TextileHelper

  def textile_attachment(attachable)
    "<<'a:#{ $~[1] }'" if attachable.url =~ /\/attachments\/([^\?]+)\?[0-9]+/
  end

  def link_to_textile(caption = 'Textile')
    function = 'window.open("http://hobix.com/textile/")'

    link_to_function h(caption), function, :style => 'cursor: help;',
      :href   => 'http://hobix.com/textile/',
      :title  => 'Textile is a lightweight markup language originally developed by Dean Allen and billed as a "humane Web text generator".'
  end

  def preview_textile_link(element_id, caption = 'toggle Preview')
    function = "if ($('#{ element_id }').visible()) { %s } else { $('#{ element_id }_preview').hide(); $('#{ element_id }').show(); }"
    update_function = remote_function :update => "#{ element_id }_preview",
      :with   => "'textile=' + encodeURIComponent($('#{ element_id }').getValue())",
      :url    => admin_preview_textile_path,
      :complete => "$('#{ element_id }').hide(); $('#{ element_id }_preview').show();"

    link_to_function h(caption), function % update_function
  end
  def preview_field_for(element_id, content = '')
    style = content.blank?? 'display: none;' : ''
    content_tag :div, content, :class => 'preview', :style => style,
        :id => "#{ element_id }_preview"
  end
  

  def textilize(text)
    redcloth = RedCloth.new text
    redcloth.action_view = self

    redcloth.to_html :attachment, :textile, :strip_navigation
  end
  alias_method :textile, :textilize
  def textilize_with_navigation(text)
    redcloth = RedCloth.new text
    redcloth.action_view = self

    redcloth.to_html :attachment, :textile, :navigation
  end
  alias_method :textile_with_navigation, :textilize_with_navigation
  def textilize_without_blocks(text)
    redcloth = RedCloth.new text, [:lite_mode]
    redcloth.to_html :attachment, :textile, :strip_navigation
  end
  alias_method :textile_without_blocks, :textilize_without_blocks

  def textile_without_paragraph(text)
    textilize_without_paragraph text
  end

end
