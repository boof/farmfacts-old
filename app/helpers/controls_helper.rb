module ControlsHelper

  def markdown_button(element_id, caption = 'Preview')
    function = remote_function :update => "#{ element_id }_preview",
      :with   => "'markdown=' + encodeURIComponent($('#{ element_id }').getValue())",
      :url    => admin_preview_markdown_path

    button_to_function h(caption), function
  end

  def location_to(caption, path)
    button_to_function caption, "window.location = '#{ path }'"
  end
  def back_to(path, caption = 'Back')
    location_to caption, path
  end

  def select_bulk_action(*options)
    options.map! { |option| ["#{ option }", "bulk_#{ option.underscore }"] }
    select_tag :bulk_action, options_for_select(options)
  end

end