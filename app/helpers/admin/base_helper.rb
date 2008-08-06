module Admin::BaseHelper

  def link_to_markdown(caption = 'Markdown')
    function = 'window.open("http://daringfireball.net/projects/markdown/syntax")'

    link_to_function h(caption), function,
      :href   => 'http://daringfireball.net/projects/markdown/syntax',
      :title  => 'The single biggest source of inspiration for Markdown’s syntax is the format of plain text email.'
  end
  def markdown_button(element_id, caption = 'Preview')
    function = remote_function :update => "#{ element_id }_preview",
      :with   => "'markdown=' + encodeURIComponent($('#{ element_id }').getValue())",
      :url    => admin_preview_markdown_path

    button_to_function h(caption), function
  end

  def back_to(path, caption = 'Back')
    button_to_function caption, "window.location = '#{ path }'"
  end

end